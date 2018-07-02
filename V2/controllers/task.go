/************************************************************
** @Description: controllers
** @Author: haodaquan
** @Date:   2018-06-11 21:11
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-11 21:11
*************************************************************/
package controllers

import (
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job2/models"
)

type TaskController struct {
	BaseController
}

func (self *TaskController) List() {
	self.Data["pageTitle"] = "任务管理"
	self.display()
}

func (self *TaskController) Add() {
	self.Data["pageTitle"] = "新增任务"
	//self.Data["serverGroup"] = serverGroupLists()
	self.Data["serverGroup"] = serverGroupLists()

	//fmt.Println(self.Data["serverGroup"])
	self.Data["taskGroup"] = taskGroupLists()
	self.display()
}

func (self *TaskController) Edit() {
	self.Data["pageTitle"] = "编辑任务"

	id, _ := self.GetInt("id", 0)
	server, _ := models.TaskServerGetById(id)
	row := make(map[string]interface{})
	row["id"] = server.Id
	row["server_name"] = server.ServerName
	row["group_id"] = server.GroupId
	row["server_ip"] = server.ServerIp
	row["server_account"] = server.ServerAccount
	row["server_outer_ip"] = server.ServerOuterIp
	row["port"] = server.Port
	row["type"] = server.Type
	row["password"] = server.Password
	row["public_key_src"] = server.PublicKeySrc
	row["private_key_src"] = server.PrivateKeySrc
	row["detail"] = server.Detail
	self.Data["server"] = row
	self.Data["serverGroup"] = serverGroupLists()
	self.display()
}

func (self *TaskController) AjaxSave() {
	server_id, _ := self.GetInt("id")
	if server_id == 0 {
		server := new(models.TaskServer)
		server.ServerName = strings.TrimSpace(self.GetString("server_name"))
		server.ServerAccount = strings.TrimSpace(self.GetString("server_account"))
		server.ServerOuterIp = strings.TrimSpace(self.GetString("server_outer_ip"))
		server.ServerIp = strings.TrimSpace(self.GetString("server_ip"))
		server.PrivateKeySrc = strings.TrimSpace(self.GetString("private_key_src"))
		server.PublicKeySrc = strings.TrimSpace(self.GetString("public_key_src"))
		server.Password = strings.TrimSpace(self.GetString("password"))

		server.Detail = strings.TrimSpace(self.GetString("detail"))
		server.Type, _ = self.GetInt("type")
		server.Port, _ = self.GetInt("port")
		server.GroupId, _ = self.GetInt("group_id")

		server.CreateTime = time.Now().Unix()
		server.UpdateTime = time.Now().Unix()
		server.Status = 0

		if _, err := models.TaskServerAdd(server); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("", MSG_OK)
	}

	server, _ := models.TaskServerGetById(server_id)
	//修改
	server.Id = server_id
	server.UpdateTime = time.Now().Unix()

	server.ServerName = strings.TrimSpace(self.GetString("server_name"))
	server.ServerAccount = strings.TrimSpace(self.GetString("server_account"))
	server.ServerOuterIp = strings.TrimSpace(self.GetString("server_outer_ip"))
	server.ServerIp = strings.TrimSpace(self.GetString("server_ip"))
	server.PrivateKeySrc = strings.TrimSpace(self.GetString("private_key_src"))
	server.PublicKeySrc = strings.TrimSpace(self.GetString("public_key_src"))
	server.Detail = strings.TrimSpace(self.GetString("detail"))
	server.Password = strings.TrimSpace(self.GetString("password"))

	server.Type, _ = self.GetInt("type")
	server.Port, _ = self.GetInt("port")
	server.GroupId, _ = self.GetInt("group_id")

	if err := server.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *TaskController) AjaxDel() {
	id, _ := self.GetInt("id")
	server, _ := models.TaskServerGetById(id)
	server.UpdateTime = time.Now().Unix()
	server.Status = 1
	server.Id = id

	//TODO 查询服务器是否用于定时任务
	if err := server.Update(); err != nil {
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
	taskName := strings.TrimSpace(self.GetString("taskName"))
	StatusText := []string{
		"<font color='red'><i class='fa fa-minus-square'></i></font>",
		"<font color='green'><i class='fa fa-check-square'></i></font>",
	}

	taskGroup := taskGroupLists()
	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 0)
	//
	if taskName != "" {
		filters = append(filters, "task_name__icontains", taskName)
	}
	result, count := models.TaskGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["task_name"] = StatusText[v.Status] + "&nbsp;" + v.TaskName
		row["description"] = v.Description
		if name, ok := taskGroup[v.GroupId]; ok {
			row["group_name"] = name
		} else {
			row["group_name"] = "默认分组"
		}

		//row["status_text"] = StatusText[v.Status]
		row["status"] = v.Status
		row["pre_time"] = beego.Date(time.Unix(v.PrevTime, 0), "Y-m-d H:i:s")
		row["execute_times"] = v.ExecuteTimes

		list[k] = row
	}

	self.ajaxList("成功", MSG_OK, count, list)
}
