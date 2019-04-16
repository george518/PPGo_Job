/*
* @Author: haodaquan
* @Date:   2017-06-21 12:54:47
* @Last Modified by:   haodaquan
* @Last Modified time: 2017-06-23 11:04:25
 */

package jobs

import (
	"sync"

	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/crons"
)

var (
	mainCron *cron.Cron
	workPool chan bool
	lock     sync.Mutex
)

func init() {
	if size, _ := beego.AppConfig.Int("jobs.pool"); size > 0 {
		workPool = make(chan bool, size)
	}
	mainCron = cron.New()
	mainCron.Start()
}

func AddJob(spec string, job *Job) bool {
	lock.Lock()
	defer lock.Unlock()

	if GetEntryById(job.jobKey) != nil {
		return false
	}
	err := mainCron.AddJob(spec, job)
	if err != nil {
		beego.Error("AddJob: ", err.Error())
		return false
	}
	//fmt.Println(job)
	return true
}

func RemoveJob(jobKey int) {
	mainCron.RemoveJob(func(e *cron.Entry) bool {
		if v, ok := e.Job.(*Job); ok {
			if v.jobKey == jobKey {
				return true
			}
		}
		return false
	})
}

func GetEntryById(jobKey int) *cron.Entry {
	entries := mainCron.Entries()
	for _, e := range entries {
		if v, ok := e.Job.(*Job); ok {
			if v.jobKey == jobKey {
				return e
			}
		}
	}
	return nil
}

func GetEntries(size int) []*cron.Entry {
	ret := mainCron.Entries()
	if len(ret) > size {
		return ret[:size]
	}
	return ret
}
