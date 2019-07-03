/************************************************************
** @Description: conf
** @Author: george hao
** @Date:   2019-06-27 09:49
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-27 09:49
*************************************************************/
package main

import (
	"github.com/astaxie/beego/logs"
	"github.com/george518/PPGo_Job/agent/server"
)

func main() {
	//获取配置，修改配置
	loadconfig()
}

func loadconfig() {

	path := "/Users/haodaquan/golang/src/github.com/george518/PPGo_Job/actuator/config/conf.ini"
	server.InitConfig(path)
	logs.Info(server.C.TcpIp, server.ConfPath)
	server.SaveConfig("TcpIp", "10.32.33.22")
	logs.Info(server.C.TcpIp, server.ConfPath)

}
