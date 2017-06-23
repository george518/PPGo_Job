package main

import (
	"github.com/astaxie/beego"
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
}

func main() {
	beego.Run()
}
