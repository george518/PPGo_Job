/************************************************************
** @Description: notify
** @Author: george hao
** @Date:   2019-06-26 15:17
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-26 15:17
*************************************************************/
package server

import (
	"encoding/json"
	"fmt"
	"github.com/george518/PPGo_Job/libs"
	"strconv"
)

//启动时注册
func Register() error {
	//获取本机ip以及端口 todo ip合法性判断
	if C.TcpIp == "auto" {
		tcpIp := libs.GetHostIp(C.IpType)
		if tcpIp == "" {
			return fmt.Errorf("无法获取本机IP，请手工在配置文件里设置")
		}
		SaveConfig("TcpIp", tcpIp)
	}
	param := make(map[string]string, 0)
	if C.ServerName == "auto" {
		serverName := "agent-" + C.TcpIp + "-" + strconv.Itoa(C.TcpPort)
		SaveConfig("ServerName", serverName)
	}

	param["server_ip"] = C.TcpIp
	param["port"] = strconv.Itoa(C.TcpPort)
	param["server_name"] = C.ServerName
	param["detail"] = "自动注册执行器"
	param["connection_type"] = "2"
	param["group_id"] = C.GroupId

	if C.RegisterUrl == "" {
		return fmt.Errorf("自动注册地址配置错误")
	}
	body, err := libs.HttpGet(C.RegisterUrl, param)
	if err != nil {
		return err
	}

	m := make(map[string]interface{})
	err = json.Unmarshal([]byte(body), &m)
	if err != nil {
		return err
	}

	if _, ok := m["status"]; ok {
		if m["status"] == float64(0) {
			//回写serverId
			serverId := int(m["message"].(float64))
			SaveConfig("ServerId", strconv.Itoa(serverId))
			return nil
		} else {
			return fmt.Errorf("自动注册失败：%v", m["message"])
		}
	}

	return fmt.Errorf("自动注册失败")
}

//程序异常退出的通知
func Close() error {

	param := make(map[string]string, 0)
	param["server_ip"] = C.TcpIp
	param["port"] = strconv.Itoa(C.TcpPort)
	param["status"] = "1"

	if C.UpdateStatusUrl == "" {
		return fmt.Errorf("执行器退出通知异常，请到系统中修改状态")
	}
	body, err := libs.HttpGet(C.UpdateStatusUrl, param)
	if err != nil {
		return err
	}

	m := make(map[string]interface{})
	err = json.Unmarshal([]byte(body), &m)
	if err != nil {
		return err
	}

	if _, ok := m["status"]; ok {
		if m["status"] == float64(0) {
			return nil
		} else {
			return fmt.Errorf("执行器退出通知异常：%v", m["message"])
		}
	}

	return fmt.Errorf("执行器退出通知异常：未知原因")
}

//心跳机制
func Heartbeat() error {
	return nil
}
