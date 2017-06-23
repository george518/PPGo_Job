package main

import (
	"PPGo_Job/models"
	_ "PPGo_Job/routers"
	"github.com/astaxie/beego"
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
