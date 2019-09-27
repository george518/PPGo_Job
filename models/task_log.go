/*
* @Author: haodaquan
* @Date:   2017-06-21 12:23:22
* @Last Modified by:   haodaquan
* @Last Modified time: 2017-06-22 14:57:13
 */

package models

import (
	"encoding/json"
	"github.com/astaxie/beego/cache"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"time"
)

type TaskLog struct {
	Id          int
	TaskId      int
	ServerId    int
	ServerName  string
	Output      string
	Error       string
	Status      int
	ProcessTime int
	CreateTime  int64
}

var RunNumCache, _ = cache.NewCache("memory", `{"interval":60}`)

func (t *TaskLog) TableName() string {
	return TableName("task_log")
}

func TaskLogAdd(t *TaskLog) (int64, error) {
	return orm.NewOrm().Insert(t)
}

func TaskLogGetList(page, pageSize int, filters ...interface{}) ([]*TaskLog, int64) {
	offset := (page - 1) * pageSize

	logs := make([]*TaskLog, 0)

	query := orm.NewOrm().QueryTable(TableName("task_log"))
	if len(filters) > 0 {
		l := len(filters)
		for k := 0; k < l; k += 2 {
			query = query.Filter(filters[k].(string), filters[k+1])
		}
	}

	total, _ := query.Count()
	query.OrderBy("-id").Limit(pageSize, offset).All(&logs)

	return logs, total
}

func TaskLogGetById(id int) (*TaskLog, error) {
	obj := &TaskLog{
		Id: id,
	}

	err := orm.NewOrm().Read(obj)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func TaskLogDelById(id int) error {
	_, err := orm.NewOrm().Delete(&TaskLog{Id: id})
	return err
}

func TaskLogDelByTaskId(taskId int) (int64, error) {
	return orm.NewOrm().QueryTable(TableName("task_log")).Filter("task_id", taskId).Delete()
}

func GetLogNum(status int) (int64, error) {
	return orm.NewOrm().QueryTable(TableName("task_log")).Filter("status", status).Count()
}

type SumDays struct {
	Day string
	Sum int
}

func SumByDays(limit int, status string) orm.Params {

	var m = map[string]string{
		"0":  "okNum",
		"-1": "errNum",
		"-2": "expiredRun"}

	res := make(orm.Params)
	key := m[status]

	if RunNumCache.IsExist(key) {
		json.Unmarshal(RunNumCache.Get(key).([]byte), &res)
		logs.Info("cache")
		return res
	}
	_, err := orm.NewOrm().Raw("SELECT FROM_UNIXTIME(create_time,'%Y-%m-%d') days,COUNT(id) count FROM pp_task_log WHERE status in(?) GROUP BY days ORDER BY days DESC limit ?;",
		status, limit).RowsToMap(&res, "days", "count")

	if err != nil {
		return nil
	}

	data, err := json.Marshal(res)
	if err != nil {
		return nil
	}
	RunNumCache.Put(key, data, 2*time.Hour)
	return res

}
