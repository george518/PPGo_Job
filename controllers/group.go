/*
* @Author: haodaquan
* @Date:   2017-06-21 10:27:40
* @Last Modified by:   haodaquan
* @Last Modified time: 2017-06-22 09:17:22
 */

package controllers

import (
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/libs"
	"github.com/george518/PPGo_Job/models"
	"strconv"
	"strings"
)

type GroupController struct {
	BaseController
}

func (this *GroupController) List() {
	page, _ := this.GetInt("page")
	if page < 1 {
		page = 1
	}

	list, count := models.TaskGroupGetList(page, this.pageSize)

	this.Data["pageTitle"] = "分组列表"
	this.Data["list"] = list
	this.Data["pageBar"] = libs.NewPager(page, int(count), this.pageSize, beego.URLFor("GroupController.List"), true).ToString()
	this.display()
}

func (this *GroupController) Add() {
	if this.isPost() {
		group := new(models.TaskGroup)
		group.GroupName = strings.TrimSpace(this.GetString("group_name"))
		group.UserId = this.userId
		group.Description = strings.TrimSpace(this.GetString("description"))

		_, err := models.TaskGroupAdd(group)
		if err != nil {
			this.ajaxMsg(err.Error(), MSG_ERR)
		}
		this.ajaxMsg("", MSG_OK)
	}

	this.Data["pageTitle"] = "添加分组"
	this.display()
}

func (this *GroupController) Edit() {
	id, _ := this.GetInt("id")

	group, err := models.TaskGroupGetById(id)
	if err != nil {
		this.showMsg(err.Error())
	}

	if this.isPost() {
		group.GroupName = strings.TrimSpace(this.GetString("group_name"))
		group.Description = strings.TrimSpace(this.GetString("description"))
		err := group.Update()
		if err != nil {
			this.ajaxMsg(err.Error(), MSG_ERR)
		}
		this.ajaxMsg("", MSG_OK)
	}

	this.Data["pageTitle"] = "编辑分组"
	this.Data["group"] = group
	this.display()
}

func (this *GroupController) Batch() {
	action := this.GetString("action")
	ids := this.GetStrings("ids")
	if len(ids) < 1 {
		this.ajaxMsg("请选择要操作的项目", MSG_ERR)
	}

	for _, v := range ids {
		id, _ := strconv.Atoi(v)
		if id < 1 {
			continue
		}
		switch action {
		case "delete":
			models.TaskGroupDelById(id)
			models.TaskResetGroupId(id)
		}
	}

	this.ajaxMsg("", MSG_OK)
}
