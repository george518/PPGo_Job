/**********************************************
** @Des: This file ...
** @Author: haodaquan
** @Date:   2017-09-14 14:23:32
** @Last Modified by:   haodaquan
** @Last Modified time: 2017-09-17 11:31:13
***********************************************/
package controllers

import (
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/models"
)

type RoleController struct {
	BaseController
}

func (self *RoleController) List() {
	self.Data["pageTitle"] = "角色管理"
	self.display()
}

func (self *RoleController) Add() {
	self.Data["zTree"] = true //引入ztreecss
	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)
	self.Data["serverGroup"] = serverLists(self.serverGroups, self.userId)
	self.Data["pageTitle"] = "新增角色"
	self.display()
}
func (self *RoleController) Edit() {
	self.Data["zTree"] = true //引入ztreecss
	self.Data["pageTitle"] = "编辑角色"

	self.Data["taskGroup"] = taskGroupLists(self.taskGroups, self.userId)
	self.Data["serverGroup"] = serverLists(self.serverGroups, self.userId)

	id, _ := self.GetInt("id", 0)
	role, _ := models.RoleGetById(id)
	row := make(map[string]interface{})
	row["id"] = role.Id
	row["role_name"] = role.RoleName
	row["detail"] = role.Detail
	row["task_group_ids"] = role.TaskGroupIds
	row["server_group_ids"] = role.ServerGroupIds
	self.Data["role"] = row

	//获取选择的树节点
	roleAuth, _ := models.RoleAuthGetById(id)
	authId := make([]int, 0)
	for _, v := range roleAuth {
		authId = append(authId, v.AuthId)
	}

	taskGroupIdsArr := strings.Split(role.TaskGroupIds, ",")
	taskGroupIds := make([]int, 0)
	for _, v := range taskGroupIdsArr {
		id, _ := strconv.Atoi(v)
		taskGroupIds = append(taskGroupIds, id)
	}

	serverGroupIdsArr := strings.Split(role.ServerGroupIds, ",")
	serverGroupIds := make([]int, 0)
	for _, v := range serverGroupIdsArr {
		id, _ := strconv.Atoi(v)
		serverGroupIds = append(serverGroupIds, id)
	}

	self.Data["server_group_ids"] = serverGroupIds
	self.Data["task_group_ids"] = taskGroupIds

	self.Data["auth"] = authId
	self.display()
}

func (self *RoleController) AjaxSave() {
	role := new(models.Role)
	role.RoleName = strings.TrimSpace(self.GetString("role_name"))
	role.Detail = strings.TrimSpace(self.GetString("detail"))
	role.ServerGroupIds = strings.TrimSpace(self.GetString("server_group_ids"))
	role.TaskGroupIds = strings.TrimSpace(self.GetString("task_group_ids"))
	role.CreateTime = time.Now().Unix()
	role.UpdateTime = time.Now().Unix()
	role.Status = 1

	auths := strings.TrimSpace(self.GetString("nodes_data"))
	role_id, _ := self.GetInt("id")
	if role_id == 0 {
		//新增
		role.CreateTime = time.Now().Unix()
		role.UpdateTime = time.Now().Unix()
		role.CreateId = self.userId
		role.UpdateId = self.userId
		if id, err := models.RoleAdd(role); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		} else {
			ras := make([]models.RoleAuth, 0)
			authsSlice := strings.Split(auths, ",")
			for _, v := range authsSlice {
				//ra := new(models.RoleAuth)
				ra := models.RoleAuth{}
				aid, _ := strconv.Atoi(v)
				ra.AuthId = aid
				ra.RoleId = id
				ras = append(ras, ra)
			}
			if len(ras) > 0 {
				models.RoleAuthBatchAdd(&ras)
			}
		}
		self.ajaxMsg("", MSG_OK)
	}
	//修改
	role.Id = role_id
	role.UpdateTime = time.Now().Unix()
	role.UpdateId = self.userId
	if err := role.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	} else {
		// 删除该角色权限
		models.RoleAuthDelete(role_id)

		ras := make([]models.RoleAuth, 0)
		authsSlice := strings.Split(auths, ",")
		for _, v := range authsSlice {
			//ra := new(models.RoleAuth)
			ra := models.RoleAuth{}
			aid, _ := strconv.Atoi(v)
			ra.AuthId = aid
			ra.RoleId = int64(role_id)
			ras = append(ras, ra)
		}
		if len(ras) > 0 {
			models.RoleAuthBatchAdd(&ras)
		}
	}
	self.ajaxMsg("", MSG_OK)
}

func (self *RoleController) AjaxDel() {

	role_id, _ := self.GetInt("id")
	role, _ := models.RoleGetById(role_id)
	role.Status = 0
	role.Id = role_id
	role.UpdateTime = time.Now().Unix()

	if err := role.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	// 删除该角色权限
	//models.RoleAuthDelete(role_id)
	self.ajaxMsg("", MSG_OK)
}

func (self *RoleController) Table() {
	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}

	roleName := strings.TrimSpace(self.GetString("roleName"))
	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 1)
	if roleName != "" {
		filters = append(filters, "role_name__icontains", roleName)
	}
	result, count := models.RoleGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["role_name"] = v.RoleName
		row["detail"] = v.Detail
		row["create_time"] = beego.Date(time.Unix(v.CreateTime, 0), "Y-m-d H:i:s")
		row["update_time"] = beego.Date(time.Unix(v.UpdateTime, 0), "Y-m-d H:i:s")
		list[k] = row
	}
	self.ajaxList("成功", MSG_OK, count, list)
}
