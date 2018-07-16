/************************************************************
** @Description: models
** @Author: haodaquan
** @Date:   2018-06-11 21:26
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-11 21:26
*************************************************************/
package models

import (
	"fmt"
	"time"

	"github.com/astaxie/beego/orm"
)

const (
	TASK_SUCCESS = 0  // 任务执行成功
	TASK_ERROR   = -1 // 任务执行出错
	TASK_TIMEOUT = -2 // 任务执行超时
)

type Task struct {
	Id           int
	GroupId      int
	ServerId     int
	TaskName     string
	Description  string
	CronSpec     string
	Concurrent   int
	Command      string
	Timeout      int
	ExecuteTimes int
	PrevTime     int64
	Status       int
	CreateId     int
	UpdateId     int
	CreateTime   int64
	UpdateTime   int64
}

func (t *Task) TableName() string {
	return TableName("task")
}

func (t *Task) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(t, fields...); err != nil {
		return err
	}
	return nil
}

func TaskAdd(task *Task) (int64, error) {
	if task.TaskName == "" {
		return 0, fmt.Errorf("任务名称不能为空")
	}

	if task.CronSpec == "" {
		return 0, fmt.Errorf("时间表达式不能为空")
	}
	if task.Command == "" {
		return 0, fmt.Errorf("命令内容不能为空")
	}
	if task.CreateTime == 0 {
		task.CreateTime = time.Now().Unix()
	}
	return orm.NewOrm().Insert(task)
}

func TaskGetList(page, pageSize int, filters ...interface{}) ([]*Task, int64) {
	offset := (page - 1) * pageSize

	tasks := make([]*Task, 0)

	query := orm.NewOrm().QueryTable(TableName("task"))
	if len(filters) > 0 {
		l := len(filters)
		for k := 0; k < l; k += 2 {
			query = query.Filter(filters[k].(string), filters[k+1])
		}
	}
	total, _ := query.Count()
	query.OrderBy("-id").Limit(pageSize, offset).All(&tasks)

	return tasks, total
}

func TaskResetGroupId(groupId int) (int64, error) {
	return orm.NewOrm().QueryTable(TableName("task")).Filter("group_id", groupId).Update(orm.Params{
		"group_id": 0,
	})
}

func TaskGetById(id int) (*Task, error) {
	task := &Task{
		Id: id,
	}

	err := orm.NewOrm().Read(task)
	if err != nil {
		return nil, err
	}
	return task, nil
}

//修改为逻辑删除
func TaskDel(id int) (int64, error) {
	return orm.NewOrm().QueryTable(TableName("task")).Filter("id", id).Update(orm.Params{
		"status": -1,
	})
	//_, err := orm.NewOrm().QueryTable(TableName("task")).Filter("id", id).Delete()
	//return err
}
