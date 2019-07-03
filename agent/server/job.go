/************************************************************
** @Description: job
** @Author: george hao
** @Date:   2019-06-24 15:14
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-24 15:14
*************************************************************/
package server

import (
	"bytes"
	"fmt"
	"github.com/astaxie/beego/logs"
	. "github.com/george518/PPGo_Job/jobs"
	"github.com/george518/PPGo_Job/libs"
	"github.com/george518/PPGo_Job/models"
	"os/exec"
	"runtime"
	"runtime/debug"
	"sync"
	"time"
)

//执行句柄map
var CmdMap sync.Map

func SetCmdMap(key string, cmd *exec.Cmd) {
	if _, ok := CmdMap.Load(key); ok {
		Counter.Store(key, cmd)
	}
}

func GetCmdMap(key string) *exec.Cmd {
	if v, ok := CmdMap.Load(key); ok {
		return v.(*exec.Cmd)
	}

	return nil
}

func RestJobFromTask(task *models.Task, serverId int) (*Job, error) {

	if task.Id < 1 {
		return nil, fmt.Errorf("ToJob: 缺少id")
	}

	if task.ServerIds == "" {
		return nil, fmt.Errorf("任务执行失败，找不到执行的服务器")
	}

	job := ResetCommandJob(task.Id, serverId, task.TaskName, task.Command)
	job.Task = task
	job.Concurrent = task.Concurrent == 1
	job.ServerId = serverId
	job.ServerName = "执行器"

	return job, nil
}

func ResetCommandJob(id int, serverId int, name string, command string) *Job {
	job := &Job{
		Id:   id,
		Name: name,
	}

	job.JobKey = libs.JobKey(id, serverId)
	job.RunFunc = func(timeout time.Duration) (jobResult *JobResult) {
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

		jobResult = new(JobResult)
		jobResult.ErrMsg = libs.GbkAsUtf8(bufErr.String())
		jobResult.OutMsg = libs.GbkAsUtf8(bufOut.String())
		jobResult.IsOk = true
		if err != nil {
			jobResult.IsOk = false
		}

		jobResult.IsTimeout = isTimeout

		return
	}
	return job
}
func runCmdWithTimeout(cmd *exec.Cmd, timeout time.Duration) (error, bool) {
	done := make(chan error)
	go func() {
		done <- cmd.Wait()
	}()

	var err error
	select {
	case <-time.After(timeout):
		logs.Warn(fmt.Sprintf("任务执行时间超过%d秒，进程将被强制杀掉: %d", int(timeout/time.Second), cmd.Process.Pid))
		go func() {
			<-done // 读出上面的goroutine数据，避免阻塞导致无法退出
		}()
		if err = cmd.Process.Kill(); err != nil {
			logs.Error(fmt.Sprintf("进程无法杀掉: %d, 错误信息: %s", cmd.Process.Pid, err))
		}
		return err, true
	case err = <-done:
		return err, false
	}
}

func Run(j *Job) *JobResult {

	defer func() {
		if err := recover(); err != nil {
			logs.Error(err, "\n", string(debug.Stack()))
		}
	}()

	logs.Debug(fmt.Sprintf("开始执行任务: %d", j.JobKey))

	j.Status++
	defer func() {
		j.Status--
	}()

	timeout := time.Duration(time.Hour * 24)
	if j.Task.Timeout > 0 {
		timeout = time.Second * time.Duration(j.Task.Timeout)
	}

	return j.RunFunc(timeout)
}
