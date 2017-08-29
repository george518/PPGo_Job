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

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/models"
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
		cmd := exec.Command("sh", "-c", command)
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
	j.logId, _ = models.TaskLogAdd(log)

	// 更新上次执行时间
	j.task.PrevTime = t.Unix()
	j.task.ExecuteTimes++
	j.task.Update("PrevTime", "ExecuteTimes")

	// 发送邮件通知
	//if (j.task.Notify == 1 && err != nil) || j.task.Notify == 2 {
	//	user, uerr := models.UserGetById(j.task.UserId)
	//	if uerr != nil {
	//		return
	//	}
	//
	//	var title string
	//
	//	data := make(map[string]interface{})
	//	data["task_id"] = j.task.Id
	//	data["username"] = user.UserName
	//	data["task_name"] = j.task.TaskName
	//	data["start_time"] = beego.Date(t, "Y-m-d H:i:s")
	//	data["process_time"] = float64(ut) / 1000
	//	data["output"] = cmdOut
	//
	//	if isTimeout {
	//		title = fmt.Sprintf("任务执行结果通知 #%d: %s", j.task.Id, "超时")
	//		data["status"] = fmt.Sprintf("超时（%d秒）", int(timeout/time.Second))
	//	} else if err != nil {
	//		title = fmt.Sprintf("任务执行结果通知 #%d: %s", j.task.Id, "失败")
	//		data["status"] = "失败（" + err.Error() + "）"
	//	} else {
	//		title = fmt.Sprintf("任务执行结果通知 #%d: %s", j.task.Id, "成功")
	//		data["status"] = "成功"
	//	}
	//
	//	content := new(bytes.Buffer)
	//	mailTpl.Execute(content, data)
	//	ccList := make([]string, 0)
	//	if j.task.NotifyEmail != "" {
	//		ccList = strings.Split(j.task.NotifyEmail, "\n")
	//	}
	//	if !mail.SendMail(user.Email, user.UserName, title, content.String(), ccList) {
	//		beego.Error("发送邮件超时：", user.Email)
	//	}
	//}
}
