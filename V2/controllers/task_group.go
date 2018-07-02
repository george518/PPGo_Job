/************************************************************
** @Description: controllers
** @Author: haodaquan
** @Date:   2018-06-10 22:24
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-10 22:24
*************************************************************/
package controllers

import (
	"strings"
	"time"

	"fmt"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job2/models"
)

type GroupController struct {
	BaseController
}

func (self *GroupController) List() {
	self.Data["pageTitle"] = "任务分组管理"
	self.display()
}

func (self *GroupController) Add() {
	self.Data["pageTitle"] = "新增分组"
	self.display()
}
func (self *GroupController) Edit() {
	self.Data["pageTitle"] = "编辑分组"

	id, _ := self.GetInt("id", 0)
	group, _ := models.GroupGetById(id)
	row := make(map[string]interface{})
	row["id"] = group.Id
	row["group_name"] = group.GroupName
	row["description"] = group.Description
	self.Data["group"] = row
	self.display()
}

func (self *GroupController) AjaxSave() {
	group := new(models.Group)
	group.GroupName = strings.TrimSpace(self.GetString("group_name"))
	group.Description = strings.TrimSpace(self.GetString("description"))
	group.Status = 1

	group_id, _ := self.GetInt("id")

	fmt.Println(group_id)
	if group_id == 0 {
		//新增
		group.CreateTime = time.Now().Unix()
		group.UpdateTime = time.Now().Unix()
		group.CreateId = self.userId
		group.UpdateId = self.userId
		if _, err := models.GroupAdd(group); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("", MSG_OK)
	}
	//修改
	group.Id = group_id
	group.UpdateTime = time.Now().Unix()
	group.UpdateId = self.userId
	if err := group.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *GroupController) AjaxDel() {

	group_id, _ := self.GetInt("id")
	group, _ := models.GroupGetById(group_id)
	group.Status = 0
	group.Id = group_id
	group.UpdateTime = time.Now().Unix()
	//TODO 如果分组下有任务 不处理
	//filters := make([]interface{}, 0)
	//filters = append(filters, "group_id", group_id)
	//filters = append(filters, "status", 0)
	//_, n := models.TaskServerGetList(1, 1, filters...)
	//if n > 0 {
	//	self.ajaxMsg("分组下有服务器资源，请先处理", MSG_ERR)
	//}
	if err := group.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *GroupController) Table() {
	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}

	groupName := strings.TrimSpace(self.GetString("groupName"))
	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 1)
	if groupName != "" {
		filters = append(filters, "group_name__contains", groupName)
	}
	result, count := models.GroupGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["group_name"] = v.GroupName
		row["description"] = v.Description
		row["create_time"] = beego.Date(time.Unix(v.CreateTime, 0), "Y-m-d H:i:s")
		row["update_time"] = beego.Date(time.Unix(v.UpdateTime, 0), "Y-m-d H:i:s")
		list[k] = row
	}
	self.ajaxList("成功", MSG_OK, count, list)
}
