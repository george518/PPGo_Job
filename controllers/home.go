/**********************************************
** @Des: This file ...
** @Author: haodaquan
** @Date:   2017-09-08 10:21:13
** @Last Modified by:   haodaquan
** @Last Modified time: 2017-09-09 18:04:41
***********************************************/
package controllers

import (
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/jobs"
	"github.com/george518/PPGo_Job/libs"
	"github.com/george518/PPGo_Job/models"
	"runtime"
	"time"
)

type HomeController struct {
	BaseController
}

func (self *HomeController) Index() {
	self.Data["pageTitle"] = "系统首页"
	//self.display()
	self.TplName = "public/main.html"
}

func (self *HomeController) Help() {
	self.Data["pageTitle"] = "Cron表达式说明"
	//self.display()
	self.TplName = "public/help.html"
}

func (self *HomeController) Start() {
	groups_map := serverGroupLists(self.serverGroups, self.userId)
	//计算总任务数量
	_, count := models.TaskGetList(1, 300)
	// 即将执行的任务
	entries := jobs.GetEntries(30)
	jobList := make([]map[string]interface{}, len(entries))
	startJob := 0 //即将执行的任务
	for k, v := range entries {
		row := make(map[string]interface{})
		job := v.Job.(*jobs.Job)
		task, _ := models.TaskGetById(job.GetId())
		row["task_id"] = job.GetId()
		row["task_name"] = job.GetName()
		row["task_group"] = groups_map[task.GroupId]
		row["next_time"] = beego.Date(v.Next, "Y-m-d H:i:s")
		jobList[k] = row
		startJob++
	}

	// 最近执行的日志
	logs, _ := models.TaskLogGetList(1, 20)
	recentLogs := make([]map[string]interface{}, len(logs))
	failJob := 0 //最近失败的数量
	okJob := 0   //最近成功的数量
	for k, v := range logs {
		task, err := models.TaskGetById(v.TaskId)
		taskName := ""
		if err == nil {
			taskName = task.TaskName
		}
		row := make(map[string]interface{})
		row["task_name"] = taskName
		row["id"] = v.Id
		row["start_time"] = beego.Date(time.Unix(v.CreateTime, 0), "Y-m-d H:i:s")
		row["process_time"] = float64(v.ProcessTime) / 1000
		row["ouput_size"] = libs.SizeFormat(float64(len(v.Output)))
		row["output"] = beego.Substr(v.Output, 0, 100)
		row["status"] = v.Status
		recentLogs[k] = row
		if v.Status != 0 {
			failJob++
		} else {
			okJob++
		}
	}

	// 最近执行失败的日志
	logs, _ = models.TaskLogGetList(1, 20, "status__lt", 0)
	errLogs := make([]map[string]interface{}, len(logs))

	for k, v := range logs {
		task, err := models.TaskGetById(v.TaskId)
		taskName := ""
		if err == nil {
			taskName = task.TaskName
		}

		row := make(map[string]interface{})
		row["task_name"] = taskName
		row["id"] = v.Id
		row["start_time"] = beego.Date(time.Unix(v.CreateTime, 0), "Y-m-d H:i:s")
		row["process_time"] = float64(v.ProcessTime) / 1000
		row["ouput_size"] = libs.SizeFormat(float64(len(v.Output)))
		row["error"] = beego.Substr(v.Error, 0, 100)
		row["status"] = v.Status
		errLogs[k] = row

	}

	self.Data["startJob"] = startJob
	self.Data["okJob"] = okJob
	self.Data["failJob"] = failJob
	self.Data["totalJob"] = count

	self.Data["recentLogs"] = recentLogs
	// this.Data["errLogs"] = errLogs
	self.Data["jobs"] = jobList
	self.Data["cpuNum"] = runtime.NumCPU()
	self.display()

	self.Data["pageTitle"] = "系统概况"
	self.display()
}
