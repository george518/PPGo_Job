/**********************************************
** @Des: 权限因子
** @Author: haodaquan
** @Date:   2017-09-09 16:14:31
** @Last Modified by:   haodaquan
** @Last Modified time: 2017-09-17 11:23:40
***********************************************/

package controllers

import (
	"fmt"
	"strings"
	"time"

	"github.com/george518/PPGo_Job/models"
)

type AuthController struct {
	BaseController
}

func (self *AuthController) Index() {

	self.Data["pageTitle"] = "权限因子"
	self.display()
}

func (self *AuthController) List() {
	self.Data["zTree"] = true //引入ztreecss
	self.Data["pageTitle"] = "权限因子"
	self.display()
}

//获取全部节点
func (self *AuthController) GetNodes() {
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 1)
	result, count := models.AuthGetList(1, 1000, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["pId"] = v.Pid
		row["name"] = v.AuthName
		row["open"] = true
		list[k] = row
	}

	self.ajaxList("成功", MSG_OK, count, list)
}

//获取一个节点
func (self *AuthController) GetNode() {
	id, _ := self.GetInt("id")
	result, _ := models.AuthGetById(id)
	// if err == nil {
	// 	self.ajaxMsg(err.Error(), MSG_ERR)
	// }
	row := make(map[string]interface{})
	row["id"] = result.Id
	row["pid"] = result.Pid
	row["auth_name"] = result.AuthName
	row["auth_url"] = result.AuthUrl
	row["sort"] = result.Sort
	row["is_show"] = result.IsShow
	row["icon"] = result.Icon

	fmt.Println(row)

	self.ajaxList("成功", MSG_OK, 0, row)
}

//新增或修改
func (self *AuthController) AjaxSave() {
	auth := new(models.Auth)
	auth.UserId = self.userId
	auth.Pid, _ = self.GetInt("pid")
	auth.AuthName = strings.TrimSpace(self.GetString("auth_name"))
	auth.AuthUrl = strings.TrimSpace(self.GetString("auth_url"))
	auth.Sort, _ = self.GetInt("sort")
	auth.IsShow, _ = self.GetInt("is_show")
	auth.Icon = strings.TrimSpace(self.GetString("icon"))
	auth.UpdateTime = time.Now().Unix()

	auth.Status = 1

	id, _ := self.GetInt("id")
	if id == 0 {
		//新增
		auth.CreateTime = time.Now().Unix()
		auth.CreateId = self.userId
		auth.UpdateId = self.userId
		if _, err := models.AuthAdd(auth); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
	} else {
		auth.Id = id
		auth.UpdateId = self.userId
		if err := auth.Update(); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
	}

	self.ajaxMsg("", MSG_OK)
}

//删除
func (self *AuthController) AjaxDel() {
	id, _ := self.GetInt("id")
	auth, _ := models.AuthGetById(id)
	auth.Id = id
	auth.Status = 0
	if err := auth.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("", MSG_OK)
}
