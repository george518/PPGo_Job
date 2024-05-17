/*
* @Author: haodaquan
* @Date:   2017-06-21 12:56:08
* @Last Modified by:   Bee
* @Last Modified time: 2019-02-17 22:10:15
 */

package jobs

import (
	"bytes"
	"errors"
	"fmt"
	"github.com/astaxie/beego/logs"
	"github.com/george518/PPGo_Job/libs"
	"github.com/george518/PPGo_Job/models"
	"net"
	"net/rpc"
	"net/rpc/jsonrpc"
	"os"
	"os/exec"
	"runtime/debug"
	"sync"
	"time"

	"runtime"
	"strconv"
	"strings"

	"encoding/json"
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/notify"
	"github.com/linxiaozhi/go-telnet"
	"golang.org/x/crypto/ssh"
)

type Job struct {
	JobKey     int                            // jobId = id*10000+serverId
	Id         int                            // taskID
	LogId      int64                          // 日志记录ID
	ServerId   int                            // 执行器信息
	ServerName string                         // 执行器名称
	ServerType int                            // 执行器类型，2-agent 1-telnet 0-ssh
	Name       string                         // 任务名称
	Task       *models.Task                   // 任务对象
	RunFunc    func(time.Duration) *JobResult // 执行函数
	Status     int                            // 任务状态，大于0表示正在执行中
	Concurrent bool                           // 同一个任务是否允许并行执行
}

type JobResult struct {
	OutMsg    string
	ErrMsg    string
	IsOk      bool
	IsTimeout bool
}

//调度计数器
var Counter sync.Map

func GetCounter(key string) int {
	if v, ok := Counter.LoadOrStore(key, 0); ok {
		n := v.(int)
		return n
	}
	return 0
}

func SetCounter(key string) {
	if v, ok := Counter.Load(key); ok {
		n := v.(int)
		m := n + 1
		if n > 1000 {
			m = 0
		}
		Counter.Store(key, m)
	}
}

func NewJobFromTask(task *models.Task) ([]*Job, error) {
	if task.Id < 1 {
		return nil, fmt.Errorf("ToJob: 缺少id")
	}

	if task.ServerIds == "" {
		return nil, fmt.Errorf("任务执行失败，找不到执行的服务器")
	}

	TaskServerIdsArr := strings.Split(task.ServerIds, ",")
	jobArr := make([]*Job, 0)
	for _, server_id := range TaskServerIdsArr {
		if server_id == "0" {
			//本地执行
			job := NewCommandJob(task.Id, 0, task.TaskName, task.Command)
			job.Task = task
			job.Concurrent = false
			if task.Concurrent == 1 {
				job.Concurrent = true
			}
			//job.Concurrent = task.Concurrent == 1
			job.ServerId = 0
			job.ServerName = "本地服务器"
			jobArr = append(jobArr, job)
		} else {
			server_id_int, _ := strconv.Atoi(server_id)
			//远程执行
			server, _ := models.TaskServerGetById(server_id_int)

			if server.Status == 2 {
				fmt.Println("服务器已禁用")
				continue
			}

			if server.ConnectionType == 0 {
				if server.Type == 0 {
					//密码验证登录服务器
					job := RemoteCommandJobByPassword(task.Id, server_id_int, task.TaskName, task.Command, server)
					job.Task = task
					job.Concurrent = false
					if task.Concurrent == 1 {
						job.Concurrent = true
					}
					//job.Concurrent = task.Concurrent == 1
					job.ServerId = server_id_int
					job.ServerName = server.ServerName
					jobArr = append(jobArr, job)
				} else {
					job := RemoteCommandJob(task.Id, server_id_int, task.TaskName, task.Command, server)
					job.Task = task
					job.Concurrent = false
					if task.Concurrent == 1 {
						job.Concurrent = true
					}
					//job.Concurrent = task.Concurrent == 1
					job.ServerId = server_id_int
					job.ServerName = server.ServerName
					jobArr = append(jobArr, job)
				}
			} else if server.ConnectionType == 1 {
				if server.Type == 0 {
					//密码验证登录服务器
					job := RemoteCommandJobByTelnetPassword(task.Id, server_id_int, task.TaskName, task.Command, server)
					job.Task = task
					job.Concurrent = false
					if task.Concurrent == 1 {
						job.Concurrent = true
					}
					//job.Concurrent = task.Concurrent == 1
					job.ServerId = server_id_int
					job.ServerName = server.ServerName
					jobArr = append(jobArr, job)
				}
			} else if server.ConnectionType == 2 {
				//密码验证登录服务器
				job := RemoteCommandJobByAgentPassword(task.Id, server_id_int, task.TaskName, task.Command, server)
				job.Task = task
				job.Concurrent = false
				if task.Concurrent == 1 {
					job.Concurrent = true
				}
				//job.Concurrent = task.Concurrent == 1
				job.ServerId = server_id_int
				job.ServerName = server.ServerName
				jobArr = append(jobArr, job)

			}
		}
	}

	return jobArr, nil
}

func NewCommandJob(id int, serverId int, name string, command string) *Job {
	job := &Job{
		Id:   id,
		Name: name,
	}

	job.JobKey = libs.JobKey(id, serverId)
	job.RunFunc = func(timeout time.Duration) (jobresult *JobResult) {
		bufOut := new(bytes.Buffer)
		bufErr := new(bytes.Buffer)
		//cmd := exec.Command("/bin/bash", "-c", command)
		var cmd *exec.Cmd
		if runtime.GOOS == "windows" {
			cmd = exec.Command("CMD", "/C", command)
		} else {
			cmd = exec.Command("sh", "-c", command)
		}
		cmd.Stdout = bufOut
		cmd.Stderr = bufErr
		cmd.Start()
		err, isTimeout := runCmdWithTimeout(cmd, timeout)
		jobresult = new(JobResult)
		jobresult.OutMsg = bufOut.String()
		jobresult.ErrMsg = bufErr.String()

		jobresult.IsOk = true
		if err != nil {
			jobresult.IsOk = false
		}

		jobresult.IsTimeout = isTimeout

		return jobresult
	}
	return job
}

//远程执行任务 密钥验证
func RemoteCommandJob(id int, serverId int, name string, command string, servers *models.TaskServer) *Job {
	job := &Job{
		Id:       id,
		Name:     name,
		ServerId: serverId,
	}

	job.JobKey = libs.JobKey(id, serverId)

	job.RunFunc = func(timeout time.Duration) (jobresult *JobResult) {
		jobresult = new(JobResult)
		jobresult.OutMsg = ""
		jobresult.ErrMsg = ""
		jobresult.IsTimeout = false
		jobresult.IsOk = true

		key, err := os.ReadFile(servers.PrivateKeySrc)
		if err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("读取私钥失败，%v", err.Error())
			return
		}
		// Create the Signer for this private key.
		signer, err := ssh.ParsePrivateKey(key)
		if err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("创建签名失败，%v", err.Error())
			return
		}
		addr := fmt.Sprintf("%s:%d", servers.ServerIp, servers.Port)
		config := &ssh.ClientConfig{
			User: servers.ServerAccount,
			Auth: []ssh.AuthMethod{
				// Use the PublicKeys method for remote authentication.
				ssh.PublicKeys(signer),
			},
			//HostKeyCallback: ssh.FixedHostKey(hostKey),
			HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
				return nil
			},
		}
		// Connect to the remote server and perform the SSH handshake.47.93.220.5
		client, err := ssh.Dial("tcp", addr, config)
		if err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败，%v", err.Error())
			return
		}

		defer client.Close()

		session, err := client.NewSession()
		if err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败，%v", err.Error())
			return
		}
		defer session.Close()

		// Once a Session is created, you can execute a single command on
		// the remote side using the Run method.

		var b bytes.Buffer
		var c bytes.Buffer
		session.Stdout = &b
		session.Stderr = &c
		jobresult.IsTimeout = false
		//session.Output(command)
		if err := session.Run(command); err != nil {
			jobresult.ErrMsg = c.String()
			jobresult.OutMsg = b.String()
			jobresult.IsOk = false
			return
		}
		jobresult.OutMsg = b.String()
		jobresult.ErrMsg = c.String()
		jobresult.IsOk = true

		return
	}
	return job
}

func RemoteCommandJobByPassword(id int, serverId int, name string, command string, servers *models.TaskServer) *Job {
	var (
		auth         []ssh.AuthMethod
		addr         string
		clientConfig *ssh.ClientConfig
		client       *ssh.Client
		session      *ssh.Session
		err          error
	)

	job := &Job{
		Id:         id,
		Name:       name,
		ServerId:   serverId,
		ServerType: servers.ConnectionType,
	}
	job.JobKey = libs.JobKey(id, serverId)
	job.RunFunc = func(timeout time.Duration) (jobresult *JobResult) {
		jobresult = new(JobResult)
		jobresult.OutMsg = ""
		jobresult.ErrMsg = ""
		jobresult.IsTimeout = false
		jobresult.IsOk = true

		// get auth method
		auth = make([]ssh.AuthMethod, 0)
		auth = append(auth, ssh.Password(servers.Password))

		clientConfig = &ssh.ClientConfig{
			User: servers.ServerAccount,
			Auth: auth,
			HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
				return nil
			},
			//Timeout: 1000 * time.Second,
		}

		// connet to ssh
		addr = fmt.Sprintf("%s:%d", servers.ServerIp, servers.Port)

		if client, err = ssh.Dial("tcp", addr, clientConfig); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("连接服务器失败，%v", err.Error())
			return
		}

		defer client.Close()

		// create session
		if session, err = client.NewSession(); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("连接服务器失败，%v", err.Error())
			return
		}

		var b bytes.Buffer
		var c bytes.Buffer
		session.Stdout = &b
		session.Stderr = &c
		//session.Output(command)
		if err := session.Run(command); err != nil {
			jobresult.IsOk = false
		}
		jobresult.OutMsg = b.String()
		jobresult.ErrMsg = c.String()
		return
	}

	return job
}

func RemoteCommandJobByTelnetPassword(id int, serverId int, name string, command string, servers *models.TaskServer) *Job {

	job := &Job{
		Id:       id,
		Name:     name,
		ServerId: serverId,
	}

	job.JobKey = libs.JobKey(id, serverId)
	job.RunFunc = func(timeout time.Duration) (jobresult *JobResult) {
		jobresult = new(JobResult)
		jobresult.OutMsg = ""
		jobresult.ErrMsg = ""
		jobresult.IsTimeout = false
		jobresult.IsOk = true

		addr := fmt.Sprintf("%s:%d", servers.ServerIp, servers.Port)
		conn, err := gote.DialTimeout("tcp", addr, timeout)
		if err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败0，%v", err.Error())
			return
		}

		defer conn.Close()

		buf := make([]byte, 4096)

		if _, err = conn.Read(buf); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败-1，%v", err.Error())
			return
		}

		if _, err = conn.Write([]byte(servers.ServerAccount + "\r\n")); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败-2，%v", err.Error())
			return
		}

		if _, err = conn.Read(buf); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败-3，%v", err.Error())
			return
		}

		if _, err = conn.Write([]byte(servers.Password + "\r\n")); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败-4，%v", err.Error())
			return
		}

		if _, err = conn.Read(buf); err != nil {
			jobresult.IsOk = false
			jobresult.ErrMsg = fmt.Sprintf("服务器连接失败-5，%v", err.Error())
			return
		}

		loginStr := libs.GbkAsUtf8(string(buf[:]))
		if !strings.Contains(loginStr, ">") {
			jobresult.ErrMsg = jobresult.ErrMsg + "Login failed!"
			jobresult.IsOk = false
			return
		}

		commandArr := strings.Split(command, "\n")

		out, n := "", 0
		for _, c := range commandArr {
			_, err = conn.Write([]byte(c + "\r\n"))
			if err != nil {
				jobresult.ErrMsg = fmt.Sprintf("服务器连接失败-6，%v", err.Error())
				jobresult.IsOk = false
				return
			}

			n, err = conn.Read(buf)

			out = out + libs.GbkAsUtf8(string(buf[0:n]))
			if err != nil ||
				strings.Contains(out, "'"+c+"' is not recognized as an internal or external command") ||
				strings.Contains(out, "'"+c+"' 不是内部或外部命令，也不是可运行的程序") {
				jobresult.ErrMsg = jobresult.ErrMsg + " " + libs.GbkAsUtf8(string(buf[0:n]))
				jobresult.IsOk = false
				jobresult.OutMsg = out
				return
			}
		}
		jobresult.IsOk = true
		jobresult.OutMsg = out
		return
	}

	return job
}

func RemoteCommandJobByAgentPassword(id int, serverId int, name string, command string, servers *models.TaskServer) *Job {

	job := &Job{
		Id:         id,
		Name:       name,
		ServerType: servers.ConnectionType,
	}

	job.JobKey = libs.JobKey(id, serverId)
	job.RunFunc = func(timeout time.Duration) *JobResult {
		return new(JobResult)
	}
	return job

}

func (j *Job) GetStatus() int {
	return j.Status
}

func (j *Job) GetName() string {
	return j.Name
}

func (j *Job) GetId() int {
	return j.Id
}

func (j *Job) GetLogId() int64 {
	return j.LogId
}

type RpcResult struct {
	Status  int
	Message string
}

func (j *Job) agentRun() (reply *JobResult) {

	server, _ := models.TaskServerGetById(j.ServerId)
	conn, err := net.Dial("tcp", fmt.Sprintf("%s:%d", server.ServerIp, server.Port))
	reply = new(JobResult)
	if err != nil {
		logs.Error("Net error:", err)
		reply.IsOk = false
		reply.ErrMsg = "Net error:" + err.Error()
		reply.IsTimeout = false
		reply.OutMsg = ""
		return reply
	}

	defer conn.Close()
	client := rpc.NewClientWithCodec(jsonrpc.NewClientCodec(conn))

	defer client.Close()
	reply = new(JobResult)

	task := j.Task
	err = client.Call("RpcTask.RunTask", task, &reply)
	if err != nil {
		reply.IsOk = false
		reply.ErrMsg = "Net error:" + err.Error()
		reply.IsTimeout = false
		reply.OutMsg = ""
		return reply
	}
	return
}

func TestServer(server *models.TaskServer) error {
	if server.ConnectionType == 0 {
		switch server.Type {
		case 0:
			//密码登录
			return libs.RemoteCommandByPassword(server)
		case 1:
			//密钥登录
			return libs.RemoteCommandByKey(server)
		default:
			return errors.New("未知的登录方式")

		}
	} else if server.ConnectionType == 1 {
		if server.Type == 0 {
			//密码登录]
			return libs.RemoteCommandByTelnetPassword(server)
		} else {
			return errors.New("Telnet方式暂不支持密钥登陆！")
		}

	} else if server.ConnectionType == 2 {
		return libs.RemoteAgent(server)
	}

	return errors.New("未知错误")
}

func PollServer(j *Job) bool {
	//判断是否是当前执行器执行
	TaskServerIdsArr := strings.Split(j.Task.ServerIds, ",")
	num := len(TaskServerIdsArr)

	if num == 0 {
		return false
	}

	count := GetCounter(strconv.Itoa(j.Task.Id))
	index := count % num
	pollServerId, _ := strconv.Atoi(TaskServerIdsArr[index])

	if j.ServerId != pollServerId {
		return false
	}

	//本地服务器
	if pollServerId == 0 {
		return true
	}

	//判断执行器或者服务器是否存活
	server, _ := models.TaskServerGetById(pollServerId)

	if server.Status != 0 {
		return false
	}

	if err := TestServer(server); err != nil {
		server.Status = 1
		server.Update()
		return false
	} else {
		server.Status = 0
		server.Update()
	}

	return true

}

func (j *Job) Run() {
	//执行策略 轮询
	if j.Task.ServerType == 1 {
		if !PollServer(j) {
			return
		} else {
			SetCounter(strconv.Itoa(j.Task.Id))
		}
	}

	if !j.Concurrent && j.Status > 0 {
		beego.Warn(fmt.Sprintf("任务[%d]上一次执行尚未结束，本次被忽略。", j.JobKey))
		return
	}

	defer func() {
		if err := recover(); err != nil {
			beego.Error(err, "\n", string(debug.Stack()))
		}
	}()

	if workPool != nil {
		workPool <- true
		defer func() {
			<-workPool
		}()
	}

	beego.Debug(fmt.Sprintf("开始执行任务: %d", j.JobKey))

	j.Status++
	defer func() {
		j.Status--
	}()

	t := time.Now()
	timeout := time.Duration(time.Hour * 24)
	if j.Task.Timeout > 0 {
		timeout = time.Second * time.Duration(j.Task.Timeout)
	}

	var jobResult = new(JobResult)
	//anget
	if j.ServerType == 2 {
		jobResult = j.agentRun()
	} else {
		jobResult = j.RunFunc(timeout)
	}

	ut := time.Now().Sub(t) / time.Millisecond

	// 插入日志
	log := new(models.TaskLog)
	log.TaskId = j.Id
	log.ServerId = j.ServerId
	log.ServerName = j.ServerName
	log.Output = jobResult.OutMsg
	log.Error = jobResult.ErrMsg
	log.ProcessTime = int(ut)
	log.CreateTime = t.Unix()

	if jobResult.IsTimeout {
		log.Status = models.TASK_TIMEOUT
		log.Error = fmt.Sprintf("任务执行超过 %d 秒\n----------------------\n%s\n", int(timeout/time.Second), jobResult.ErrMsg)
	} else if !jobResult.IsOk {
		log.Status = models.TASK_ERROR
		log.Error = "ERROR:" + jobResult.ErrMsg
	}

	if log.Status < 0 && j.Task.IsNotify == 1 {
		if j.Task.NotifyUserIds != "0" && j.Task.NotifyUserIds != "" {
			adminInfo := AllAdminInfo(j.Task.NotifyUserIds)
			phone := make(map[string]string, 0)
			dingtalk := make(map[string]string, 0)
			wechat := make(map[string]string, 0)
			toEmail := ""
			for _, v := range adminInfo {
				if v.Phone != "0" && v.Phone != "" {
					phone[v.Phone] = v.Phone
				}
				if v.Email != "0" && v.Email != "" {
					toEmail += v.Email + ";"
				}
				if v.Dingtalk != "0" && v.Dingtalk != "" {
					dingtalk[v.Dingtalk] = v.Dingtalk
				}
				if v.Wechat != "0" && v.Wechat != "" {
					wechat[v.Wechat] = v.Wechat
				}
			}
			toEmail = strings.TrimRight(toEmail, ";")

			TextStatus := []string{
				"超时",
				"错误",
				"正常",
			}

			status := log.Status + 2

			title, content, taskOutput, errOutput := "", "", "", ""

			notifyTpl, err := models.NotifyTplGetById(j.Task.NotifyTplId)
			if err != nil {
				notifyTpl, err := models.NotifyTplGetByTplType(j.Task.NotifyType, models.NotifyTplTypeSystem)
				if err == nil {
					title = notifyTpl.Title
					content = notifyTpl.Content
				}
			} else {
				title = notifyTpl.Title
				content = notifyTpl.Content
			}

			taskOutput = strings.Replace(log.Output, "\n", " ", -1)
			taskOutput = strings.Replace(taskOutput, "\"", "\\\"", -1)
			errOutput = strings.Replace(log.Error, "\n", " ", -1)
			errOutput = strings.Replace(errOutput, "\"", "\\\"", -1)

			if title != "" {
				title = strings.Replace(title, "{{TaskId}}", strconv.Itoa(j.Task.Id), -1)
				title = strings.Replace(title, "{{ServerId}}", strconv.Itoa(j.ServerId), -1)
				title = strings.Replace(title, "{{TaskName}}", j.Task.TaskName, -1)
				title = strings.Replace(title, "{{ExecuteCommand}}", j.Task.Command, -1)
				title = strings.Replace(title, "{{ExecuteTime}}", beego.Date(time.Unix(log.CreateTime, 0), "Y-m-d H:i:s"), -1)
				title = strings.Replace(title, "{{ProcessTime}}", strconv.FormatFloat(float64(log.ProcessTime)/1000, 'f', 6, 64), -1)
				title = strings.Replace(title, "{{ExecuteStatus}}", TextStatus[status], -1)
				title = strings.Replace(title, "{{TaskOutput}}", taskOutput, -1)
				title = strings.Replace(title, "{{ErrorOutput}}", errOutput, -1)
			}

			if content != "" {
				content = strings.Replace(content, "{{TaskId}}", strconv.Itoa(j.Task.Id), -1)
				content = strings.Replace(content, "{{ServerId}}", strconv.Itoa(j.ServerId), -1)
				content = strings.Replace(content, "{{TaskName}}", j.Task.TaskName, -1)
				content = strings.Replace(content, "{{ExecuteCommand}}", strings.Replace(j.Task.Command, "\"", "\\\"", -1), -1)
				content = strings.Replace(content, "{{ExecuteTime}}", beego.Date(time.Unix(log.CreateTime, 0), "Y-m-d H:i:s"), -1)
				content = strings.Replace(content, "{{ProcessTime}}", strconv.FormatFloat(float64(log.ProcessTime)/1000, 'f', 6, 64), -1)
				content = strings.Replace(content, "{{ExecuteStatus}}", TextStatus[status], -1)
				content = strings.Replace(content, "{{TaskOutput}}", taskOutput, -1)
				content = strings.Replace(content, "{{ErrorOutput}}", errOutput, -1)
			}

			if j.Task.NotifyType == 0 && toEmail != "" {
				//邮件
				mailtype := "html"
				ok := notify.SendToChan(toEmail, title, content, mailtype)
				if !ok {
					fmt.Println("发送邮件错误", toEmail)
				}
			} else if j.Task.NotifyType == 1 && len(phone) > 0 {
				//信息
				param := make(map[string]string)
				err := json.Unmarshal([]byte(content), &param)
				if err != nil {
					fmt.Println("发送信息错误", err)
					return
				}

				ok := notify.SendSmsToChan(phone, param)
				if !ok {
					fmt.Println("发送信息错误", phone)
				}
			} else if j.Task.NotifyType == 2 && len(dingtalk) > 0 {
				//钉钉
				param := make(map[string]interface{})

				err := json.Unmarshal([]byte(content), &param)
				if err != nil {
					fmt.Println("发送钉钉错误", err)
					return
				}

				ok := notify.SendDingtalkToChan(dingtalk, param)
				if !ok {
					fmt.Println("发送钉钉错误", dingtalk)
				}
			} else if j.Task.NotifyType == 3 && len(wechat) > 0 {
				//微信
				param := make(map[string]string)
				err := json.Unmarshal([]byte(content), &param)
				if err != nil {
					fmt.Println("发送微信错误", err)
					return
				}

				ok := notify.SendWechatToChan(phone, param)
				if !ok {
					fmt.Println("发送微信错误", phone)
				}
			}
		}
	}

	j.LogId, _ = models.TaskLogAdd(log)

	// 更新上次执行时间
	j.Task.PrevTime = t.Unix()
	j.Task.ExecuteTimes++
	j.Task.Update("PrevTime", "ExecuteTimes")
}

//冗余代码
type adminInfo struct {
	Id       int
	Email    string
	Phone    string
	Dingtalk string
	Wechat   string
	RealName string
}

func AllAdminInfo(adminIds string) []*adminInfo {
	Filters := make([]interface{}, 0)
	Filters = append(Filters, "status", 1)
	//Filters = append(Filters, "id__gt", 1)
	var notifyUserIds []int
	if adminIds != "0" && adminIds != "" {
		notifyUserIdsStr := strings.Split(adminIds, ",")
		for _, v := range notifyUserIdsStr {
			i, _ := strconv.Atoi(v)
			notifyUserIds = append(notifyUserIds, i)
		}
		Filters = append(Filters, "id__in", notifyUserIds)
	}
	Result, _ := models.AdminGetList(1, 1000, Filters...)

	adminInfos := make([]*adminInfo, 0)
	for _, v := range Result {
		ai := adminInfo{
			Id:       v.Id,
			Email:    v.Email,
			Phone:    v.Phone,
			Dingtalk: v.Dingtalk,
			Wechat:   v.Wechat,
			RealName: v.RealName,
		}
		adminInfos = append(adminInfos, &ai)
	}

	return adminInfos
}
