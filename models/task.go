/************************************************************
** @Description: models
** @Author: haodaquan
** @Date:   2018-06-11 21:26
** @Last Modified by:   Bee
** @Last Modified time: 2019-02-15 21:32
*************************************************************/
package models

import (
	"fmt"
	"strconv"
	"time"

	"github.com/astaxie/beego/orm"
)

const (
	TASK_SUCCESS = 0  // 任务执行成功
	TASK_ERROR   = -1 // 任务执行出错
	TASK_TIMEOUT = -2 // 任务执行超时
)

type Task struct {
	Id            int
	GroupId       int
	ServerIds     string
	ServerType    int
	TaskName      string
	Description   string
	CronSpec      string
	Concurrent    int
	Command       string
	Timeout       int
	ExecuteTimes  int
	PrevTime      int64
	Status        int
	IsNotify      int
	NotifyType    int
	NotifyTplId   int
	NotifyUserIds string
	CreateId      int
	UpdateId      int
	CreateTime    int64
	UpdateTime    int64
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
	query.OrderBy("-status", "task_name", "-id").Limit(pageSize, offset).All(&tasks)

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

//运行总次数
func TaskTotalRunNum() (int64, error) {

	res := make(orm.Params)
	_, err := orm.NewOrm().Raw("select sum(execute_times) as num,task_name from pp_task").RowsToMap(&res, "num", "task_name")

	if err != nil {
		return 0, err
	}

	for k, _ := range res {
		i64, err := strconv.ParseInt(k, 10, 64)
		if err != nil {
			return 0, err
		}

		return i64, nil

	}
	return 0, nil
}
