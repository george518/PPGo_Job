/************************************************************
** @Description: task
** @Author: george hao
** @Date:   2019-06-24 13:22
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-24 13:22
*************************************************************/
package server

import (
	"github.com/astaxie/beego/logs"
	"github.com/george518/PPGo_Job/jobs"
	"github.com/george518/PPGo_Job/models"
)

type RpcTask struct {
}

type RpcResult struct {
	Status  int
	Message string
}

//Execute once
func (r *RpcTask) RunTask(task *models.Task, Result *jobs.JobResult) error {
	server_id := C.ServerId
	job, err := RestJobFromTask(task, server_id)
	if err != nil {
		return nil
	}
	*Result = *(Run(job))
	return nil
}

//Kill execution
func (r *RpcTask) KillCommand(task models.Task, reply *RpcResult) error {
	reply.Status = 200
	reply.Message = "Ok kill " + task.TaskName
	return nil
}

func (r *RpcTask) HeartBeat(ping string, reply *RpcResult) error {
	reply.Status = 200
	reply.Message = ping + " pong"
	logs.Info(ping)
	return nil
}
