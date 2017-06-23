package main

import (
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/controllers"
	"github.com/george518/PPGo_Job/jobs"
	_ "github.com/george518/PPGo_Job/mail"
	"github.com/george518/PPGo_Job/models"
	_ "github.com/george518/PPGo_Job/routers"
)

const (
	VERSION = "1.0.0"
)

func init() {
	//初始化数据模型
	models.Init()
	jobs.InitJobs()

}

func main() {
	beego.Run()
}
