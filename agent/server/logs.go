/************************************************************
** @Description: log
** @Author: haodaquan
** @Date:   2018-08-22 23:00
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-08-22 23:00
*************************************************************/
package server

import (
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
)

var Env string

func init() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
}

//http相关
func WriteLog(r *http.Request, t time.Time, match string, pattern string) {

	if C.AppMode != "prod" {
		d := time.Now().Sub(t)
		l := fmt.Sprintf("[ACCESS] | % -10s | % -40s | % -16s | % -10s | % -40s |",
			r.Method, r.URL.Path, d.String(), match, pattern)
		log.Println(l)
	}
}

//系统运行相关
func NLog(level string, value ...interface{}) {
	if strings.Contains(C.LogLevel, level) || C.LogLevel == "ALL" {
		log.Println("["+level+"]", value)
		return
	}
}
