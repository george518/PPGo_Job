/************************************************************
** @Description: controllers
** @Author: haodaquan
** @Date:   2018-06-09 16:11
** @Last Modified by:   Bee
** @Last Modified time: 2019-02-17 22:15:15
*************************************************************/
package controllers

import (
	"fmt"
	"github.com/george518/PPGo_Job/models"
	"golang.org/x/crypto/ssh"
	"io/ioutil"
	"net"
	"strconv"
	"strings"
	"time"
	"github.com/linxiaozhi/go-telnet"
	"github.com/pkg/errors"
)

type ServerController struct {
	BaseController
}

func (self *ServerController) List() {
	self.Data["pageTitle"] = "资源管理"
	self.Data["serverGroup"] = serverGroupLists(self.serverGroups, self.userId)
	self.display()
}

func (self *ServerController) Add() {
	self.Data["pageTitle"] = "新增服务器资源"
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
	self.Data["pageTitle"] = "编辑服务器资源"

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
			err = RemoteCommandByPassword(server)
		}

		if server.Type == 1 {
			//密钥登录
			err = RemoteCommandByKey(server)
		}

		if err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("Success", MSG_OK)
	} else if server.ConnectionType == 1 {
		if server.Type == 0 {
			//密码登录
			err = RemoteCommandByTelnetPassword(server)
		} else {
			self.ajaxMsg("Telnet方式暂不支持密钥登陆！", MSG_ERR)
		}

		if err != nil {
			self.ajaxMsg(err.Error(), MSG_ERR)
		}
		self.ajaxMsg("Success", MSG_OK)
	}

	self.ajaxMsg("未知连接方式", MSG_ERR)
}

func RemoteCommandByTelnetPassword(servers *models.TaskServer) error {

	addr := fmt.Sprintf("%s:%d", servers.ServerIp, servers.Port)
	conn, err := gote.DialTimeout("tcp", addr, time.Second*10)
	if err != nil {
		return err
	}

	defer conn.Close()

	buf := make([]byte, 4096)
	_, err = conn.Read(buf)
	if err != nil {
		return err
	}

	_, err = conn.Write([]byte(servers.ServerAccount + "\r\n"))
	if err != nil {
		return err
	}

	_, err = conn.Read(buf)
	if err != nil {
		return err
	}

	_, err = conn.Write([]byte(servers.Password + "\r\n"))
	if err != nil {
		return err
	}

	_, err = conn.Read(buf)
	if err != nil {
		return err
	}

	str := gbkAsUtf8(string(buf[:]))

	if strings.Contains(str, ">") {
		return nil
	}

	return errors.Errorf("连接失败!")
}

func RemoteCommandByPassword(servers *models.TaskServer) error {
	var (
		auth         []ssh.AuthMethod
		addr         string
		clientConfig *ssh.ClientConfig
	)

	auth = make([]ssh.AuthMethod, 0)
	auth = append(auth, ssh.Password(servers.Password))

	clientConfig = &ssh.ClientConfig{
		User: servers.ServerAccount,
		Auth: auth,
		HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		},
		Timeout: 5 * time.Second,
	}

	addr = fmt.Sprintf("%s:%d", servers.ServerIp, servers.Port)
	client, err := ssh.Dial("tcp", addr, clientConfig)
	if err == nil {
		defer client.Close()
	}
	return err
}

func RemoteCommandByKey(servers *models.TaskServer) error {
	key, err := ioutil.ReadFile(servers.PrivateKeySrc)
	if err != nil {
		return err
	}

	signer, err := ssh.ParsePrivateKey(key)
	if err != nil {
		return err
	}
	addr := fmt.Sprintf("%s:%d", servers.ServerIp, servers.Port)
	config := &ssh.ClientConfig{
		User: servers.ServerAccount,
		Auth: []ssh.AuthMethod{
			// Use the PublicKeys method for remote authentication.
			ssh.PublicKeys(signer),
		},
		//HostKeyCallback: ssh.FixedHostKey(hostKey),
		HostKeyCallback: func(hostname string, remote net.Addr, key ssh.PublicKey) error {
			return nil
		},
		Timeout: 5 * time.Second,
	}

	client, err := ssh.Dial("tcp", addr, config)
	if err == nil {
		client.Close()
	}
	return err
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
		"正常",
		"<font color='red'>禁用</font>",
	}

	loginType := [2]string{
		"密码",
		"密钥",
	}

	connectionType := [2]string{
		"SSH",
		"Telnet",
	}

	serverGroup := serverGroupLists(self.serverGroups, self.userId)

	self.pageSize = limit
	//查询条件
	filters := make([]interface{}, 0)
	filters = append(filters, "status", 0)

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
