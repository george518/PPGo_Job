/************************************************************
** @Description: ip
** @Author: george hao
** @Date:   2019-06-27 09:22
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-27 09:22
*************************************************************/
package main

import (
	"github.com/astaxie/beego/logs"
	"github.com/george518/PPGo_Job/libs"
)

func main() {
	logs.Info(libs.PublicIp())

}
