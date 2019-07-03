/************************************************************
** @Description: common
** @Author: george hao
** @Date:   2018-11-29 11:14
** @Last Modified by:  george hao
** @Last Modified time: 2018-11-29 11:14
*************************************************************/
package common

//配置开始 注释查看配置文件
type Conf struct {
	Version         string
	AppMode         string
	LogLevel        string
	ServerName      string
	ServerId        int
	TcpPort         int
	TcpIp           string
	GroupId         string
	RegisterUrl     string
	UpdateStatusUrl string
	IpType          int
}

var ExitChan = make(chan int, 1)
