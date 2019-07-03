/************************************************************
** @Description: controllers
** @Author: haodaquan
** @Date:   2018-06-09 16:11
** @Last Modified by:   Bee
** @Last Modified time: 2019-02-17 22:15:15
*************************************************************/
package controllers

import (
	"github.com/astaxie/beego/logs"
	"github.com/george518/PPGo_Job/libs"
	"github.com/george518/PPGo_Job/models"
	"strconv"
	"strings"
	"time"
)

type ServerController struct {
	BaseController
}

func (self *ServerController) List() {
	self.Data["pageTitle"] = "执行资源管理"
	self.Data["serverGroup"] = serverGroupLists(self.serverGroups, self.userId)
	self.display()
}

func (self *ServerController) Add() {
	self.Data["pageTitle"] = "新增执行资源"
	self.Data["serverGroup"] = serverGroupLists(self.serverGroups, self.userId)
	self.display()
}

func (self *ServerController) GetServerByGroupId() {
	gid, _ := self.GetInt("gid", 0)
	if gid == 0 {
		self.ajaxMsg("groupId is not exist", MSG_ERR)
	}

	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}
	//serverName := strings.TrimSpace(self.GetString("serverName"))
	StatusText := []string{
		"正常",
		"<font color='red'>禁用</font>",
	}

	loginType := [2]string{
		"密码",
		"密钥",
	}

	serverGroup := serverGroupLists(self.serverGroups, self.userId)

	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 0)
	filters = append(filters, "group_id", gid)

	result, count := models.TaskServerGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["connection_type"] = v.ConnectionType
		row["server_name"] = v.ServerName
		row["detail"] = v.Detail
		if serverGroup[v.GroupId] == "" {
			v.GroupId = 0
		}
		row["group_name"] = serverGroup[v.GroupId]
		row["type"] = loginType[v.Type]
		row["status"] = v.Status
		row["status_text"] = StatusText[v.Status]
		list[k] = row
	}

	self.ajaxList("成功", MSG_OK, count, list)
}

func (self *ServerController) Edit() {
	self.Data["pageTitle"] = "编辑执行资源"

	id, _ := self.GetInt("id", 0)
	server, _ := models.TaskServerGetById(id)
	row := make(map[string]interface{})
	row["id"] = server.Id
	row["connection_type"] = server.ConnectionType
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
	self.Data["serverGroup"] = serverGroupLists(self.serverGroups, self.userId)
	self.display()
}

func (self *ServerController) AjaxTestServer() {

	server := new(models.TaskServer)
	server.ConnectionType, _ = self.GetInt("connection_type")
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

	var err error

	if server.ConnectionType == 0 {
		if server.Type == 0 {
			//密码登录
			err = libs.RemoteCommandByPassword(server)
		}

		if server.Type == 1 {
			//密钥登录
			err = libs.RemoteCommandByKey(server)
		}

		if err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("Success", MSG_OK)
	} else if server.ConnectionType == 1 {
		if server.Type == 0 {
			//密码登录
			err = libs.RemoteCommandByTelnetPassword(server)
		} else {
			self.ajaxMsg("Telnet方式暂不支持密钥登陆！", MSG_ERR)
		}

		if err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("Success", MSG_OK)
	} else if server.ConnectionType == 2 {

		if err := libs.RemoteAgent(server); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		} else {
			self.ajaxMsg("Success", MSG_OK)

		}
	}

	self.ajaxMsg("未知连接方式", MSG_ERR)
}

func (self *ServerController) Copy() {
	self.Data["pageTitle"] = "复制服务器资源"

	id, _ := self.GetInt("id", 0)
	server, _ := models.TaskServerGetById(id)
	row := make(map[string]interface{})
	row["id"] = server.Id
	row["connection_type"] = server.ConnectionType
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
	self.Data["serverGroup"] = serverGroupLists(self.serverGroups, self.userId)
	self.display()
}

func (self *ServerController) AjaxSave() {
	server_id, _ := self.GetInt("id")
	if server_id == 0 {
		server := new(models.TaskServer)
		server.ConnectionType, _ = self.GetInt("connection_type")
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

	server.ConnectionType, _ = self.GetInt("connection_type")
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

func (self *ServerController) AjaxDel() {
	id, _ := self.GetInt("id")

	if id == 1 {
		self.ajaxMsg("默认分组id=1，禁止删除", MSG_ERR)
	}

	server, _ := models.TaskServerGetById(id)
	server.UpdateTime = time.Now().Unix()
	server.Status = 2
	server.Id = id

	//TODO 查询服务器是否用于定时任务
	if err := server.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg("操作成功", MSG_OK)
}

func (self *ServerController) Table() {
	//列表
	page, err := self.GetInt("page")
	if err != nil {
		page = 1
	}
	limit, err := self.GetInt("limit")
	if err != nil {
		limit = 30
	}

	serverGroupId, err := self.GetInt("serverGroupId")

	serverName := strings.TrimSpace(self.GetString("serverName"))
	StatusText := []string{
		"<i class='fa fa-refresh' style='color:#5FB878'></i>",
		"<i class='fa fa-ban' style='color:#FF5722'></i>",
	}
	//
	//loginType := [2]string{
	//	"密码",
	//	"密钥",
	//}

	connectionType := [3]string{
		"SSH",
		"Telnet",
		"Agent",
	}

	serverGroup := serverGroupLists(self.serverGroups, self.userId)

	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	ids := []int{0, 1}
	filters = append(filters, "status__in", ids)

	groupsIds := make([]int, 0)
	if self.userId != 1 {
		groups := strings.Split(self.serverGroups, ",")

		for _, v := range groups {
			id, _ := strconv.Atoi(v)
			if serverGroupId > 0 {
				if id == serverGroupId {
					groupsIds = append(groupsIds, id)
					break
				}
			} else {
				groupsIds = append(groupsIds, id)
			}
		}
		filters = append(filters, "group_id__in", groupsIds)
	} else if serverGroupId > 0 {
		groupsIds = append(groupsIds, serverGroupId)
		filters = append(filters, "group_id__in", groupsIds)
	}

	if serverName != "" {
		filters = append(filters, "server_name__icontains", serverName)
	}
	result, count := models.TaskServerGetList(page, self.pageSize, filters...)
	list := make([]map[string]interface{}, len(result))
	for k, v := range result {
		row := make(map[string]interface{})
		row["id"] = v.Id
		row["connection_type"] = connectionType[v.ConnectionType]
		row["server_name"] = StatusText[v.Status] + " " + v.ServerName
		row["detail"] = v.Detail
		if serverGroup[v.GroupId] == "" {
			v.GroupId = 0
		}
		row["ip_port"] = v.ServerIp + ":" + strconv.Itoa(v.Port)
		row["group_name"] = serverGroup[v.GroupId]
		//row["type"] = loginType[v.Type]
		row["status"] = v.Status
		list[k] = row
	}

	self.ajaxList("成功", MSG_OK, count, list)
}

//以下函数为执行器接口
//注册
func (self *ServerController) ApiSave() {
	//唯一确定值 ip+port
	serverIp := strings.TrimSpace(self.GetString("server_ip"))
	port, _ := self.GetInt("port")

	if serverIp == "" || port == 0 {
		self.ajaxMsg("执行器和端口号必填", MSG_ERR)
	}

	defaultActName := "agent-" + serverIp + "-" + strconv.Itoa(port)

	id := models.TaskServerForActuator(serverIp, port)
	if id == 0 {
		//新增
		server := new(models.TaskServer)
		server.ConnectionType, _ = self.GetInt("connection_type", 3)
		server.ServerName = strings.TrimSpace(self.GetString("server_name", defaultActName))
		server.ServerAccount = strings.TrimSpace(self.GetString("server_account", "agent"))
		server.ServerOuterIp = strings.TrimSpace(self.GetString("server_outer_ip", ""))
		server.ServerIp = strings.TrimSpace(self.GetString("server_ip"))
		server.PrivateKeySrc = strings.TrimSpace(self.GetString("private_key_src", ""))
		server.PublicKeySrc = strings.TrimSpace(self.GetString("public_key_src", ""))
		server.Password = strings.TrimSpace(self.GetString("password", "agent"))

		server.Detail = strings.TrimSpace(self.GetString("detail", ""))
		server.Type, _ = self.GetInt("type", 0)
		server.Port, _ = self.GetInt("port")
		server.GroupId, _ = self.GetInt("group_id", 0)
		server.Status = 0

		server.CreateTime = time.Now().Unix()
		server.UpdateTime = time.Now().Unix()
		server.Status = 0
		serverId, err := models.TaskServerAdd(server)
		if err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg(serverId, MSG_OK)
	} else {
		//修改状态
		server, _ := models.TaskServerGetById(id)
		server.UpdateTime = time.Now().Unix()
		server.Status, _ = self.GetInt("status", 0)
		if err := server.Update(); err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg(id, MSG_OK)
	}

}

//检测0-正常，1-异常，2-删除
func (self *ServerController) ApiStatus() {
	//唯一确定值 ip+port
	serverId := strings.TrimSpace(self.GetString("server_ip"))
	port, _ := self.GetInt("port")
	status, _ := self.GetInt("status", 0)

	if serverId == "" || port == 0 {
		self.ajaxMsg("执行器和端口号必填", MSG_ERR)
	}

	id := models.TaskServerForActuator(serverId, port)
	if id == 0 {
		self.ajaxMsg("执行器不存在", MSG_ERR)
	}

	if status != 0 && status != 1 {
		status = 0
	}

	server, _ := models.TaskServerGetById(id)
	server.UpdateTime = time.Now().Unix()
	server.Status = status
	server.Id = id

	logs.Info(server)

	//TODO 查询执行器是否正在使用中
	if err := server.Update(); err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	}
	self.ajaxMsg(id, MSG_OK)
}

//获取 不检测执行器状态
func (self *ServerController) ApiGet() {
	//唯一确定值 ip+port
	serverId := strings.TrimSpace(self.GetString("server_ip"))
	port, _ := self.GetInt("port")

	if serverId == "" || port == 0 {
		self.ajaxMsg("执行器和端口号必填", MSG_ERR)
	}

	id := models.TaskServerForActuator(serverId, port)
	if id == 0 {
		self.ajaxMsg("执行器不存在", MSG_ERR)
	}

	server, err := models.TaskServerGetById(id)

	if err != nil {
		self.ajaxMsg(err.Error(), MSG_ERR)
	} else {
		self.ajaxMsg(server, MSG_OK)
	}
}
