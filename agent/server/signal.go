/************************************************************
** @Description: server
** @Author: george hao
** @Date:   2018-11-29 11:24
** @Last Modified by:  george hao
** @Last Modified time: 2018-11-29 11:24
*************************************************************/
package server

import (
	"os"
	"os/signal"
	"syscall"
)

//监听关闭状态
func ListenSignal() {
	//创建监听退出chan
	c := make(chan os.Signal)
	//监听指定信号 ctrl+c kill
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGUSR1, syscall.SIGUSR2)

	go func() {
		for s := range c {
			switch s {
			case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGUSR1, syscall.SIGUSR2:
				NLog("NOTICE", " Ready to quit close type ", s)
				//TODO 异常警报，汇报状态
				if err := Close(); err != nil {
					NLog("ERROR", err.Error())
				} else {
					NLog("NOTICE", " 执行器安全关闭...")
				}
				os.Exit(0)
			default:
				NLog("NOTICE", " close type ", s)
				os.Exit(1)
			}
		}
	}()
}
