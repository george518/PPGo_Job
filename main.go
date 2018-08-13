/************************************************************
** @Description: PPGo_Job2
** @Author: haodaquan
** @Date:   2018-06-05 22:24
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-05 22:24
*************************************************************/
package main

import (
	//"fmt"
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/jobs"
	"github.com/george518/PPGo_Job/models"
	_ "github.com/george518/PPGo_Job/routers"
	"time"
)

const (
	VERSION = "2.2.0"
)

func init() {
	//初始化数据模型
	var StartTime = time.Now().Unix()
	models.Init(StartTime)
	jobs.InitJobs()
}

func main() {
	beego.BConfig.WebConfig.Session.SessionOn = true
	beego.Run()
}
