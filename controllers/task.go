/************************************************************
** @Description: controllers
** @Author: haodaquan
** @Date:   2018-06-11 21:11
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-11 21:11
*************************************************************/
package controllers

import (
	"strconv"
	"strings"
	"time"

	"fmt"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/jobs"
	"github.com/george518/PPGo_Job/models"
	"github.com/robfig/cron"
)

type TaskController struct {
	BaseController
}

func (self *TaskController) List() {
	self.Data["pageTitle"] = "任务管理"
	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)
	self.Data["groupId"] = 0
	arr := strings.Split(self.Ctx.GetCookie("groupid"), "|")
	if len(arr) > 0 {
		self.Data["groupId"], _ = strconv.Atoi(arr[0])
	}
	self.display()
}

func (self *TaskController) AuditList() {
	self.Data["pageTitle"] = "任务审核"
	self.display()
}

func (self *TaskController) Add() {
	self.Data["pageTitle"] = "新增任务"
	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)
	self.Data["serverGroup"] = serverLists(self.serverGroups, self.userId)
	self.Data["isAdmin"] = self.userId
	self.Data["adminInfo"] = AllAdminInfo("")

	fmt.Println(self.Data["adminInfo"])
	self.display()
}

func (self *TaskController) Edit() {
	self.Data["pageTitle"] = "编辑任务"

	id, _ := self.GetInt("id")
	task, err := models.TaskGetById(id)
	if err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}

	if task.Status == 1 {
		self.ajaxMsg("运行状态无法编辑任务，请先暂停任务", MSG_ERR)
	}
	self.Data["task"] = task

	self.Data["adminInfo"] = AllAdminInfo("")

	// 分组列表
	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)
	self.Data["serverGroup"] = serverLists(self.serverGroups, self.userId)
	self.Data["isAdmin"] = self.userId
	var notifyUserIds []int
	if task.NotifyUserIds != "0" {
		notifyUserIdsStr := strings.Split(task.NotifyUserIds, ",")
		for _, v := range notifyUserIdsStr {
			i, _ := strconv.Atoi(v)
			notifyUserIds = append(notifyUserIds, i)
		}
	}

	self.Data["notify_user_ids"] = notifyUserIds
	self.display()
}

func (self *TaskController) Copy() {
	self.Data["pageTitle"] = "复制任务"
	self.Data["adminInfo"] = AllAdminInfo("")

	id, _ := self.GetInt("id")
	task, err := models.TaskGetById(id)
	if err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.Data["task"] = task

	// 分组列表
	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)
	self.Data["serverGroup"] = serverLists(self.serverGroups, self.userId)
	var notifyUserIds []int
	if task.NotifyUserIds != "0" {
		notifyUserIdsStr := strings.Split(task.NotifyUserIds, ",")
		for _, v := range notifyUserIdsStr {
			i, _ := strconv.Atoi(v)
			notifyUserIds = append(notifyUserIds, i)
		}
	}
	self.Data["notify_user_ids"] = notifyUserIds
	self.display()
}

func (self *TaskController) Detail() {
	self.Data["pageTitle"] = "任务详细"

	id, _ := self.GetInt("id")
	task, err := models.TaskGetById(id)
	if err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}

	TextStatus := []string{
		"<font color='red'><i class='fa fa-minus-square'></i> 暂停</font>",
		"<font color='green'><i class='fa fa-check-square'></i> 运行中</font>",
		"<font color='orange'><i class='fa fa-question-circle'></i> 待审核</font>",
		"<font color='red'><i class='fa fa-times-circle'></i> 审核失败</font>",
	}

	self.Data["TextStatus"] = TextStatus[task.Status]
	self.Data["CreateTime"] = beego.Date(time.Unix(task.CreateTime, 0), "Y-m-d H:i:s")
	self.Data["UpdateTime"] = beego.Date(time.Unix(task.UpdateTime, 0), "Y-m-d H:i:s")
	self.Data["task"] = task
	// 分组列表
	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)

	serverName := "本地服务器"
	if task.ServerId == 0 {
		serverName = "本地服务器"
	} else {
		server, err := models.TaskServerGetById(task.ServerId)
		if err == nil {
			serverName = server.ServerName
		}
	}

	//任务分组
	groupName := "默认分组"
	if task.GroupId > 0 {
		group, err := models.TaskGroupGetById(task.GroupId)
		if err == nil {
			groupName = group.GroupName
		}
	}

	self.Data["GroupName"] = groupName

	//创建人和修改人
	createName := "未知"
	updateName := "未知"
	if task.CreateId > 0 {
		admin, err := models.AdminGetById(task.CreateId)
		if err == nil {
			createName = admin.RealName
		}
	}

	if task.UpdateId > 0 {
		admin, err := models.AdminGetById(task.UpdateId)
		if err == nil {
			updateName = admin.RealName
		}
	}

	//是否出错通知
	self.Data["adminInfo"] = []*AdminInfo{}
	if task.NotifyUserIds != "0" && task.NotifyUserIds != "" {
		self.Data["adminInfo"] = AllAdminInfo(task.NotifyUserIds)
	}
	self.Data["CreateName"] = createName
	self.Data["UpdateName"] = updateName
	self.Data["serverName"] = serverName
	self.display()
}

func (self *TaskController) AjaxSave() {
	task_id, _ := self.GetInt("id")
	if task_id == 0 {
		task := new(models.Task)
		task.CreateId = self.userId
		task.GroupId, _ = self.GetInt("group_id")
		task.TaskName = strings.TrimSpace(self.GetString("task_name"))
		task.Description = strings.TrimSpace(self.GetString("description"))
		task.Concurrent, _ = self.GetInt("concurrent")
		task.ServerId, _ = self.GetInt("server_id")
		task.CronSpec = strings.TrimSpace(self.GetString("cron_spec"))
		task.Command = strings.TrimSpace(self.GetString("command"))
		task.Timeout, _ = self.GetInt("timeout")
		task.IsNotify, _ = self.GetInt("is_notify")
		task.NotifyType, _ = self.GetInt("notify_type")
		task.NotifyUserIds = strings.TrimSpace(self.GetString("notify_user_ids"))

		msg, isBan := checkCommand(task.Command)
		if !isBan {
			self.ajaxMsg("含有禁止命令："+msg, MSG_ERR)
		}

		task.CreateTime = time.Now().Unix()
		task.UpdateTime = time.Now().Unix()
		task.Status = 2 //审核中
		if self.userId == 1 {
			task.Status = 0 //审核中,超级管理员不需要
		}
		if task.TaskName == "" || task.CronSpec == "" || task.Command == "" {
			self.ajaxMsg("请填写完整信息", MSG_ERR)
		}
		if _, err := cron.Parse(task.CronSpec); err != nil {
			self.ajaxMsg("cron表达式无效", MSG_ERR)
		}
		if _, err := models.TaskAdd(task); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}

		self.ajaxMsg("", MSG_OK)
	}

	task, _ := models.TaskGetById(task_id)
	//修改
	task.Id = task_id
	task.UpdateTime = time.Now().Unix()
	task.TaskName = strings.TrimSpace(self.GetString("task_name"))
	task.Description = strings.TrimSpace(self.GetString("description"))
	task.GroupId, _ = self.GetInt("group_id")
	task.Concurrent, _ = self.GetInt("concurrent")
	task.ServerId, _ = self.GetInt("server_id")
	task.CronSpec = strings.TrimSpace(self.GetString("cron_spec"))
	task.Command = strings.TrimSpace(self.GetString("command"))
	task.Timeout, _ = self.GetInt("timeout")
	task.IsNotify, _ = self.GetInt("is_notify")
	task.NotifyType, _ = self.GetInt("notify_type")
	task.NotifyUserIds = strings.TrimSpace(self.GetString("notify_user_ids"))
	task.UpdateId = self.userId
	task.Status = 2 //审核中,超级管理员不需要
	if self.userId == 1 {
		task.Status = 0
	}
	msg, isBan := checkCommand(task.Command)
	if !isBan {
		self.ajaxMsg("含有禁止命令："+msg, MSG_ERR)
	}

	if err := task.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

//检查是否含有禁用命令
func checkCommand(command string) (string, bool) {

	filters := make([]interface{}, 0)
	filters = append(filters, "status", 0)
	ban, _ := models.BanGetList(1, 1000, filters...)
	for _, v := range ban {
		if strings.Contains(command, v.Code) {
			return v.Code, false
		}
	}
	return "", true
}

func (self *TaskController) AjaxAudit() {

	taskId, _ := self.GetInt("id")
	if taskId == 0 {
		self.ajaxMsg("任务不存在", MSG_ERR)
	}
	res := changeStatus(taskId, 0, self.userId)
	if !res {
		self.ajaxMsg("审核失败", MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxNopass() {
	taskId, _ := self.GetInt("id")
	if taskId == 0 {
		self.ajaxMsg("任务不存在", MSG_ERR)
	}
	res := changeStatus(taskId, 3, self.userId)
	if !res {
		self.ajaxMsg("操作失败", MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxStart() {
	taskId, _ := self.GetInt("id")
	if taskId == 0 {
		self.ajaxMsg("任务不存在", MSG_ERR)
	}

	task, err := models.TaskGetById(taskId)
	if err != nil {
		self.ajaxMsg("查不到该任务", MSG_ERR)
	}

	if task.Status != 0 {
		self.ajaxMsg("任务状态有误", MSG_ERR)
	}

	job, err := jobs.NewJobFromTask(task)
	if err != nil {
		self.ajaxMsg("创建任务失败", MSG_ERR)
	}

	if jobs.AddJob(task.CronSpec, job) {
		task.Status = 1
		task.Update()
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxPause() {
	taskId, _ := self.GetInt("id")
	if taskId == 0 {
		self.ajaxMsg("任务不存在", MSG_ERR)
	}

	task, err := models.TaskGetById(taskId)
	if err != nil {
		self.ajaxMsg("查不到该任务", MSG_ERR)
	}

	jobs.RemoveJob(taskId)
	task.Status = 0
	task.Update()
	self.ajaxMsg("", MSG_OK)

}

// 立即执行
func (self *TaskController) AjaxRun() {
	id, _ := self.GetInt("id")
	task, err := models.TaskGetById(id)
	if err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}

	job, err := jobs.NewJobFromTask(task)
	if err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	job.Run()
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxBatchStart() {
	idArr := self.GetStrings("ids")
	ids := strings.Split(idArr[0], ",")
	if len(ids) < 1 {
		self.ajaxMsg("请选择要操作的任务", MSG_ERR)
	}
	for _, v := range ids {
		id, _ := strconv.Atoi(v)
		if id < 1 {
			continue
		}

		if task, err := models.TaskGetById(id); err == nil {
			job, err := jobs.NewJobFromTask(task)
			if err == nil {
				jobs.AddJob(task.CronSpec, job)
				task.Status = 1
				task.Update()
			}
		}
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxBatchPause() {
	idArr := self.GetStrings("ids")
	ids := strings.Split(idArr[0], ",")
	if len(ids) < 1 {
		self.ajaxMsg("请选择要操作的任务", MSG_ERR)
	}
	for _, v := range ids {
		id, _ := strconv.Atoi(v)
		if id < 1 {
			continue
		}
		jobs.RemoveJob(id)

		if task, err := models.TaskGetById(id); err == nil {
			task.Status = 0
			task.Update()
		}
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxBatchDel() {
	idArr := self.GetStrings("ids")
	ids := strings.Split(idArr[0], ",")
	if len(ids) < 1 {
		self.ajaxMsg("请选择要操作的任务", MSG_ERR)
	}
	for _, v := range ids {
		id, _ := strconv.Atoi(v)
		if id < 1 {
			continue
		}
		models.TaskDel(id)
		models.TaskLogDelByTaskId(id)
		jobs.RemoveJob(id)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxBatchAudit() {
	idArr := self.GetStrings("ids")
	ids := strings.Split(idArr[0], ",")
	if len(ids) < 1 {
		self.ajaxMsg("请选择要操作的任务", MSG_ERR)
	}
	for _, v := range ids {
		id, _ := strconv.Atoi(v)
		if id < 1 {
			continue
		}
		changeStatus(id, 0, self.userId)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxBatchNoPass() {
	idArr := self.GetStrings("ids")
	ids := strings.Split(idArr[0], ",")
	if len(ids) < 1 {
		self.ajaxMsg("请选择要操作的任务", MSG_ERR)
	}
	for _, v := range ids {
		id, _ := strconv.Atoi(v)
		if id < 1 {
			continue
		}
		changeStatus(id, 3, self.userId)
	}
	self.ajaxMsg("", MSG_OK)
}

func changeStatus(taskId, status, userId int) bool {

	if taskId == 0 {
		return false
	}
	task, _ := models.TaskGetById(taskId)
	//修改
	task.Id = taskId
	task.UpdateTime = time.Now().Unix()
	task.UpdateId = userId
	task.Status = status //0,1,2,3,9

	if err := task.Update(); err != nil {
		return false
	}
	return true
}

func (self *TaskController) AjaxDel() {
	id, _ := self.GetInt("id")
	task, _ := models.TaskGetById(id)

	task.UpdateTime = time.Now().Unix()
	task.UpdateId = self.userId
	task.Status = -1
	task.Id = id

	//TODO 查询服务器是否用于定时任务
	if err := task.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("操作成功", MSG_OK)
}

func (self *TaskController) Table() {
	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}

	groupId, _ := self.GetInt("group_id", -1)

	//0-全部，-1如果存在，n,如果不存在，0

	if groupId == -1 {
		groupId = 0
		arr := strings.Split(self.Ctx.GetCookie("groupid"), "|")
		if len(arr) > 0 {
			groupId, _ = strconv.Atoi(arr[0])
		}
	}

	if groupId > 0 {
		self.Ctx.SetCookie("groupid", strconv.Itoa(groupId)+"|job")
	}

	status, _ := self.GetInt("status")

	taskName := strings.TrimSpace(self.GetString("taskName"))
	StatusText := []string{
		"<font color='red'><i class='fa fa-minus-square'></i></font>",
		"<font color='green'><i class='fa fa-check-square'></i></font>",
		"<font color='orange'><i class='fa fa-question-circle'></i></font>",
		"<font color='red'><i class='fa fa-times-circle'></i></font>",
	}

	taskGroup := taskGroupLists(self.taskGroups, self.userId)
	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)

	if status == 2 {
		//审核中，审核失败
		ids := []int{2, 3}
		filters = append(filters, "status__in", ids)
	} else {
		ids := []int{0, 1}
		filters = append(filters, "status__in", ids)
	}
	//搜索全部
	if groupId == 0 {
		if self.userId != 1 {
			groups := strings.Split(self.taskGroups, ",")

			groupsIds := make([]int, 0)
			for _, v := range groups {
				id, _ := strconv.Atoi(v)
				groupsIds = append(groupsIds, id)
			}
			filters = append(filters, "group_id__in", groupsIds)
		}
	} else if groupId > 0 {
		filters = append(filters, "group_id", groupId)
	}
	if taskName != "" {
		filters = append(filters, "task_name__icontains", taskName)
	}

	result, count := models.TaskGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))

	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id

		groupName := "默认分组"

		if name, ok := taskGroup[v.GroupId]; ok {
			groupName = name
		}

		row["group_name"] = groupName
		row["task_name"] = StatusText[v.Status] + " " + groupName + "-" + "&nbsp;" + v.TaskName
		row["description"] = v.Description

		//row["status_text"] = StatusText[v.Status]
		row["status"] = v.Status
		row["pre_time"] = beego.Date(time.Unix(v.PrevTime, 0), "Y-m-d H:i:s")
		row["execute_times"] = v.ExecuteTimes

		e := jobs.GetEntryById(v.Id)
		if e != nil {
			row["next_time"] = beego.Date(e.Next, "Y-m-d H:i:s")
			row["prev_time"] = "-"
			if e.Prev.Unix() > 0 {
				row["prev_time"] = beego.Date(e.Prev, "Y-m-d H:i:s")
			} else if v.PrevTime > 0 {
				row["prev_time"] = beego.Date(time.Unix(v.PrevTime, 0), "Y-m-d H:i:s")
			}
			row["running"] = 1
		} else {
			row["next_time"] = "-"
			if v.PrevTime > 0 {
				row["prev_time"] = beego.Date(time.Unix(v.PrevTime, 0), "Y-m-d H:i:s")
			} else {
				row["prev_time"] = "-"
			}
			row["running"] = 0
		}

		list[k] = row
	}

	self.ajaxList("成功", MSG_OK, count, list)
}
