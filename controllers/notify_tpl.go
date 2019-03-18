/************************************************************
** @Description: controllers
** @Author: Bee
** @Date:   2019-02-15 20:21
** @Last Modified by:   Bee
** @Last Modified time: 2019-02-15 20:21
*************************************************************/
package controllers

import (
	"github.com/george518/PPGo_Job/models"
	"strings"
	"time"
	"github.com/astaxie/beego"
	"encoding/json"
)

type NotifyTplController struct {
	BaseController
}

func (self *NotifyTplController) List() {
	self.Data["pageTitle"] = "通知模板"
	self.display()
}

func (self *NotifyTplController) Add() {
	self.Data["pageTitle"] = "新增通知模板"
	self.Data["serverGroup"] = serverGroupLists(self.serverGroups, self.userId)
	self.display()
}

func (self *NotifyTplController) Edit() {
	self.Data["pageTitle"] = "编辑通知模板"

	id, _ := self.GetInt("id", 0)
	notifyTpl, _ := models.NotifyTplGetById(id)
	row := make(map[string]interface{})
	row["id"] = notifyTpl.Id
	row["tpl_name"] = notifyTpl.TplName
	row["tpl_type"] = notifyTpl.TplType
	row["title"] = notifyTpl.Title
	row["content"] = notifyTpl.Content
	row["status"] = notifyTpl.Status
	self.Data["notifyTpl"] = row
	self.display()
}

func (self *NotifyTplController) AjaxSave() {
	tpl_id, _ := self.GetInt("id")
	if tpl_id == 0 {
		notifyTpl := new(models.NotifyTpl)
		notifyTpl.TplName = strings.TrimSpace(self.GetString("tpl_name"))
		notifyTpl.TplType, _ = self.GetInt("tpl_type")
		notifyTpl.Title = strings.TrimSpace(self.GetString("title"))
		notifyTpl.Content = strings.TrimSpace(self.GetString("content"))
		notifyTpl.CreateId = self.userId
		notifyTpl.CreateTime = time.Now().Unix()
		notifyTpl.Type = models.NotifyTplTypeDefault
		notifyTpl.Status, _ = self.GetInt("status")

		if notifyTpl.TplType == 1 || notifyTpl.TplType == 3 {
			m := make(map[string]string)
			err := json.Unmarshal([]byte(notifyTpl.Content), &m)
			if err != nil {
				self.ajaxMsg("模板内容格式错误,"+err.Error(), MSG_ERR)
			}
		}

		if _, err := models.NotifyTplAdd(notifyTpl); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("", MSG_OK)
	}

	notifyTpl, _ := models.NotifyTplGetById(tpl_id)
	//修改
	notifyTpl.Id = tpl_id
	notifyTpl.UpdateId = self.userId
	notifyTpl.UpdateTime = time.Now().Unix()

	notifyTpl.TplName = strings.TrimSpace(self.GetString("tpl_name"))
	notifyTpl.TplType, _ = self.GetInt("tpl_type")
	notifyTpl.Title = strings.TrimSpace(self.GetString("title"))
	notifyTpl.Content = strings.TrimSpace(self.GetString("content"))
	notifyTpl.Status, _ = self.GetInt("status")

	if notifyTpl.TplType == 1 || notifyTpl.TplType == 3 {
		m := make(map[string]string)
		err := json.Unmarshal([]byte(notifyTpl.Content), &m)
		if err != nil {
			self.ajaxMsg("模板内容格式错误,"+err.Error(), MSG_ERR)
		}
	}

	if notifyTpl.Type == models.NotifyTplTypeSystem {
		self.ajaxMsg("系统模板禁止更新", MSG_ERR)
	}

	if err := notifyTpl.Update(); err != nil {
		self.ajaxMsg("更新失败,"+err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *NotifyTplController) AjaxDel() {
	id, _ := self.GetInt("id")
	notifyTpl, _ := models.NotifyTplGetById(id)

	if notifyTpl.Type == models.NotifyTplTypeSystem {
		self.ajaxMsg("系统模板禁止删除", MSG_ERR)
	}

	if err := models.NotifyTplDelById(id); err != nil {
		self.ajaxMsg("删除失败,"+err.Error(), MSG_ERR)
	}
	self.ajaxMsg("操作成功", MSG_OK)
}

func (self *NotifyTplController) Table() {
	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}
	tplName := strings.TrimSpace(self.GetString("tplName"))
	StatusText := []string{
		"<font color='red'>禁用</font>",
		"正常",
	}

	TplTypeText := []string{
		"邮件",
		"信息",
		"钉钉",
		"微信",
	}

	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)

	if tplName != "" {
		filters = append(filters, "tpl_name__icontains", tplName)
	}
	result, count := models.NotifyTplGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["type"] = v.Type
		row["tpl_name"] = v.TplName
		row["tpl_type"] = v.TplType
		row["tpl_type_text"] = TplTypeText[v.TplType]
		row["status"] = v.Status
		row["status_text"] = StatusText[v.Status]
		row["create_time"] = beego.Date(time.Unix(v.CreateTime, 0), "Y-m-d H:i:s")
		row["update_time"] = beego.Date(time.Unix(v.UpdateTime, 0), "Y-m-d H:i:s")
		list[k] = row
	}

	self.ajaxList("成功", MSG_OK, count, list)
}
