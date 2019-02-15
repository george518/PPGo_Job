/*
* @Author: haodaquan
* @Date:   2017-06-21 12:56:08
* @Last Modified by:   haodaquan
* @Last Modified time: 2017-06-21 13:05:57
 */

package jobs

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"os/exec"
	"runtime/debug"
	"time"

	"runtime"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/models"
	"github.com/george518/PPGo_Job/notify"
	"golang.org/x/crypto/ssh"
)

type Job struct {
	id         int                                               // 任务ID
	logId      int64                                             // 日志记录ID
	name       string                                            // 任务名称
	task       *models.Task                                      // 任务对象
	runFunc    func(time.Duration) (string, string, error, bool) // 执行函数
	status     int                                               // 任务状态，大于0表示正在执行中
	Concurrent bool                                              // 同一个任务是否允许并行执行
}

func NewJobFromTask(task *models.Task) (*Job, error) {
	if task.Id < 1 {
		return nil, fmt.Errorf("ToJob: 缺少id")
	}

	//本地程序执行
	if task.ServerId == 0 {
		job := NewCommandJob(task.Id, task.TaskName, task.Command)
		job.task = task
		job.Concurrent = task.Concurrent == 1
		return job, nil
	}

	server, _ := models.TaskServerGetById(task.ServerId)
	if server.Type == 0 {
		//密码验证登录服务器
		job := RemoteCommandJobByPassword(task.Id, task.TaskName, task.Command, server)
		job.task = task
		job.Concurrent = task.Concurrent == 1
		return job, nil
	}

	job := RemoteCommandJob(task.Id, task.TaskName, task.Command, server)
	job.task = task
	job.Concurrent = task.Concurrent == 1
	return job, nil

}

func NewCommandJob(id int, name string, command string) *Job {
	job := &Job{
		id:   id,
		name: name,
	}
	job.runFunc = func(timeout time.Duration) (string, string, error, bool) {
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

		return bufOut.String(), bufErr.String(), err, isTimeout
	}
	return job
}

//远程执行任务 密钥验证
func RemoteCommandJob(id int, name string, command string, servers *models.TaskServer) *Job {
	job := &Job{
		id:   id,
		name: name,
	}
	job.runFunc = func(timeout time.Duration) (string, string, error, bool) {

		key, err := ioutil.ReadFile(servers.PrivateKeySrc)
		if err != nil {
			return "", "", err, false
		}
		// Create the Signer for this private key.
		signer, err := ssh.ParsePrivateKey(key)
		if err != nil {
			return "", "", err, false
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
			return "", "", err, false
		}

		defer client.Close()

		session, err := client.NewSession()
		if err != nil {
			return "", "", err, false
		}
		defer session.Close()

		// Once a Session is created, you can execute a single command on
		// the remote side using the Run method.

		var b bytes.Buffer
		var c bytes.Buffer
		session.Stdout = &b
		session.Stderr = &c

		//session.Output(command)
		if err := session.Run(command); err != nil {
			return "", "", err, false
		}
		isTimeout := false
		return b.String(), c.String(), err, isTimeout
	}
	return job
}

func RemoteCommandJobByPassword(id int, name string, command string, servers *models.TaskServer) *Job {
	var (
		auth         []ssh.AuthMethod
		addr         string
		clientConfig *ssh.ClientConfig
		client       *ssh.Client
		session      *ssh.Session
		err          error
	)

	job := &Job{
		id:   id,
		name: name,
	}
	job.runFunc = func(timeout time.Duration) (string, string, error, bool) {
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
			return "", "", err, false
		}

		defer client.Close()

		// create session
		if session, err = client.NewSession(); err != nil {
			return "", "", err, false
		}

		var b bytes.Buffer
		var c bytes.Buffer
		session.Stdout = &b
		session.Stderr = &c
		//session.Output(command)
		if err := session.Run(command); err != nil {
			return "", "", err, false
		}
		isTimeout := false
		return b.String(), c.String(), err, isTimeout
	}

	return job
}

func (j *Job) Status() int {
	return j.status
}

func (j *Job) GetName() string {
	return j.name
}

func (j *Job) GetId() int {
	return j.id
}

func (j *Job) GetLogId() int64 {
	return j.logId
}

func (j *Job) Run() {
	if !j.Concurrent && j.status > 0 {
		beego.Warn(fmt.Sprintf("任务[%d]上一次执行尚未结束，本次被忽略。", j.id))
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

	beego.Debug(fmt.Sprintf("开始执行任务: %d", j.id))

	j.status++
	defer func() {
		j.status--
	}()

	t := time.Now()
	timeout := time.Duration(time.Hour * 24)
	if j.task.Timeout > 0 {
		timeout = time.Second * time.Duration(j.task.Timeout)
	}
	cmdOut, cmdErr, err, isTimeout := j.runFunc(timeout)
	ut := time.Now().Sub(t) / time.Millisecond

	// 插入日志
	log := new(models.TaskLog)
	log.TaskId = j.id
	log.Output = cmdOut
	log.Error = cmdErr
	log.ProcessTime = int(ut)
	log.CreateTime = t.Unix()

	if isTimeout {
		log.Status = models.TASK_TIMEOUT
		log.Error = fmt.Sprintf("任务执行超过 %d 秒\n----------------------\n%s\n", int(timeout/time.Second), cmdErr)
	} else if err != nil {
		log.Status = models.TASK_ERROR
		log.Error = err.Error() + ":" + cmdErr
	}

	if log.Status < 0 && j.task.IsNotify == 1 {
		if j.task.NotifyUserIds != "0" && j.task.NotifyUserIds != "" {
			adminInfo := AllAdminInfo(j.task.NotifyUserIds)
			phone := make(map[string]string, 0)
			dingtalk := make(map[string]string, 0)
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
			}
			toEmail = strings.TrimRight(toEmail, ";")

			TextStatus := []string{
				"<font color='red'>超时</font>",
				"<font color='red'>错误</font>",
				"<font color='green'>正常</font>",
			}

			status := log.Status + 2

			if j.task.NotifyType == 0 && toEmail != "" {
				//邮件
				//SendToChan(to, subject, body, mailtype string) bool
				subject := fmt.Sprintf("PPGo_Job定时任务异常：%s", j.task.TaskName)
				body := fmt.Sprintf(
					`Hello,定时任务出问题了：
<p style="font-size:16px;">任务执行详情：</p>
<p style="display:block; padding:10px; background:#efefef;border:1px solid #e4e4e4">
任务 ID：%d<br/>
任务名称：%s<br/>
执行时间：%s<br/>
执行耗时：%f秒<br/>
执行状态：%s
</p>
<p style="font-size:16px;">任务执行输出</p>
<p style="display:block; padding:10px; background:#efefef;border:1px solid #e4e4e4">
%s
</p>
<br/>
<br/>
<p>-----------------------------------------------------------------<br />
本邮件由PPGo_Job定时系统自动发出，请勿回复<br />
如果要取消邮件通知，请登录到系统进行设置<br />
</p>
`, j.task.Id,
					j.task.TaskName,
					beego.Date(time.Unix(log.CreateTime, 0), "Y-m-d H:i:s"),
					float64(log.ProcessTime)/1000,
					TextStatus[status],
					log.Error)
				mailtype := "html"

				ok := notify.SendToChan(toEmail, subject, body, mailtype)
				if !ok {
					fmt.Println("发送邮件错误", toEmail)
				}

			} else if j.task.NotifyType == 1 && len(phone) > 0 {
				//信息
				TextStatus := []string{
					" 超时",
					" 错误",
					" 正常",
				}
				param := make(map[string]string)
				param["task_id"] = " " + strconv.Itoa(j.task.Id)
				param["task_name"] = " " + j.task.TaskName
				param["status"] = " " + TextStatus[status]
				notify.SendSmsToChan(phone, param)
			} else if j.task.NotifyType == 2 && len(dingtalk) > 0 {

				TextStatus := []string{
					"超时",
					"错误",
					"正常",
				}
				content := fmt.Sprintf(
					`任务执行异常详情：
任务 ID：%d
任务名称：%s
执行时间：%s
执行耗时：%f秒
执行状态：%s
任务执行输出：
%s`,
					j.task.Id,
					j.task.TaskName,
					beego.Date(time.Unix(log.CreateTime, 0), "Y-m-d H:i:s"),
					float64(log.ProcessTime)/1000,
					TextStatus[status],
					log.Error)

				notify.SendDingtalkToChan(dingtalk, content)
			}

		}
	}

	j.logId, _ = models.TaskLogAdd(log)

	// 更新上次执行时间
	j.task.PrevTime = t.Unix()
	j.task.ExecuteTimes++
	j.task.Update("PrevTime", "ExecuteTimes")
}

//冗余代码
type adminInfo struct {
	Id       int
	Email    string
	Phone    string
	Dingtalk string
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
			RealName: v.RealName,
		}
		adminInfos = append(adminInfos, &ai)
	}

	return adminInfos
}
