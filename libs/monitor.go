/************************************************************
** @Description: libs
** @Author: george hao
** @Date:   2018-08-13 11:16
** @Last Modified by:  george hao
** @Last Modified time: 2018-08-13 11:16
*************************************************************/
package libs

import (
	"fmt"
	"runtime"
	"time"
)

func SystemInfo(startTime int64) map[string]interface{} {

	var afterLastGC string
	goNum := runtime.NumGoroutine()
	cpuNum := runtime.NumCPU()
	mstat := &runtime.MemStats{}
	runtime.ReadMemStats(mstat)
	now := time.Now().Unix()
	//costTime := int(time.Now().Sub(startTime).Seconds())
	costTime := int(now - startTime)
	mb := 1024 * 1024

	if mstat.LastGC != 0 {
		afterLastGC = fmt.Sprintf("%.1fs", float64(time.Now().UnixNano()-int64(mstat.LastGC))/1000/1000/1000)
	} else {
		afterLastGC = "0"
	}

	return map[string]interface{}{
		"服务运行时间":    fmt.Sprintf("%d天%d小时%d分%d秒", costTime/(3600*24), costTime%(3600*24)/3600, costTime%3600/60, costTime%(60)),
		"goroute数量": goNum,
		"cpu核心数":    cpuNum,

		"当前内存使用量":  FileSize(int64(mstat.Alloc)),
		"所有被分配的内存": FileSize(int64(mstat.TotalAlloc)),
		"内存占用量":    FileSize(int64(mstat.Sys)),
		"指针查找次数":   mstat.Lookups,
		"内存分配次数":   mstat.Mallocs,
		"内存释放次数":   mstat.Frees,
		"距离上次GC时间": afterLastGC,

		// "当前 Heap 内存使用量": file.FileSize(int64(mstat.HeapAlloc)),
		// "Heap 内存占用量":    file.FileSize(int64(mstat.HeapSys)),
		// "Heap 内存空闲量":    file.FileSize(int64(mstat.HeapIdle)),
		// "正在使用的 Heap 内存": file.FileSize(int64(mstat.HeapInuse)),
		// "被释放的 Heap 内存":  file.FileSize(int64(mstat.HeapReleased)),
		// "Heap 对象数量":     mstat.HeapObjects,

		"下次GC内存回收量": fmt.Sprintf("%.3fMB", float64(mstat.NextGC)/float64(mb)),
		"GC暂停时间总量":  fmt.Sprintf("%.3fs", float64(mstat.PauseTotalNs)/1000/1000/1000),
		"上次GC暂停时间":  fmt.Sprintf("%.3fs", float64(mstat.PauseNs[(mstat.NumGC+255)%256])/1000/1000/1000),
	}
}
