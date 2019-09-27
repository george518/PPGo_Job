package main

import (
	"flag"
	"github.com/george518/PPGo_Job/agent/server"
	"log"
	"runtime"
)

//文件配置路径
var configFilePath string

func initArgs() {
	//server -c ./configpath
	//defaultPath := "/Users/haodaquan/golang/src/github.com/george518/PPGo_Job/agent/config/conf.ini"
	defaultPath := "./config/conf.ini"
	flag.StringVar(&configFilePath, "c", defaultPath, "config file path request")
	flag.Parse()
}

func initEnv() {
	runtime.GOMAXPROCS(runtime.NumCPU())
}

func main() {
	var err error

	//初始化线程
	initEnv()

	//配置文件路径
	initArgs()

	//加载配置
	if err = server.InitConfig(configFilePath); err != nil {
		goto ERR
	}

	server.NLog("INFO", "配置文件读取完毕...")

	//应用关闭监控
	server.ListenSignal()

	//自动注册
	if err = server.Register(); err != nil {
		goto ERR
	}

	server.NLog("INFO", "自动注册完成...")

	server.NLog("INFO", "agent is running...")
	//监听
	if err = server.RpcRun(); err != nil {
		goto ERR
	}

ERR:
	log.Fatal(err.Error())
}
