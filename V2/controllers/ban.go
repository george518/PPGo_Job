/************************************************************
** @Description: controllers
** @Author: haodaquan
** @Date:   2018-06-10 19:50
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-10 19:50
*************************************************************/
package controllers

import (
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job2/models"
)

type BanController struct {
	BaseController
}

func (self *BanController) List() {
	self.Data["pageTitle"] = "禁用命令管理"
	self.display()
}

func (self *BanController) Add() {
	self.Data["pageTitle"] = "新增禁用命令"

	// 角色
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 1)
	result, _ := models.RoleGetList(1, 1000, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["role_name"] = v.RoleName
		list[k] = row
	}

	self.Data["role"] = list

	self.display()
}

func (self *BanController) Edit() {
	self.Data["pageTitle"] = "编辑禁用命令"

	id, _ := self.GetInt("id", 0)
	ban, _ := models.BanGetById(id)
	row := make(map[string]interface{})
	row["id"] = ban.Id
	row["code"] = ban.Code
	self.Data["ban"] = row
	self.display()
}

func (self *BanController) AjaxSave() {
	id, _ := self.GetInt("id")
	if id == 0 {
		ban := new(models.Ban)
		ban.Code = strings.TrimSpace(self.GetString("code"))
		ban.CreateTime = time.Now().Unix()

		if _, err := models.BanAdd(ban); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("", MSG_OK)
	}

	ban, _ := models.BanGetById(id)
	//修改
	ban.Id = id
	ban.UpdateTime = time.Now().Unix()
	ban.Code = strings.TrimSpace(self.GetString("code"))

	if err := ban.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *BanController) AjaxDel() {
	id, _ := self.GetInt("id")
	ban, _ := models.BanGetById(id)
	ban.UpdateTime = time.Now().Unix()
	ban.Status = 1

	if err := ban.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("操作成功", MSG_OK)
}

func (self *BanController) Table() {
	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}

	code := strings.TrimSpace(self.GetString("code"))

	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 0)
	if code != "" {
		filters = append(filters, "code__icontains", code)
	}
	result, count := models.BanGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["code"] = v.Code
		row["create_time"] = beego.Date(time.Unix(v.CreateTime, 0), "Y-m-d H:i:s")
		list[k] = row
	}
	self.ajaxList("成功", MSG_OK, count, list)
}
