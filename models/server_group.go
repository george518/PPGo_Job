/************************************************************
** @Description: models
** @Author: haodaquan
** @Date:   2018-06-08 21:49
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-08 21:49
*************************************************************/
package models

import (
	"fmt"

	"github.com/astaxie/beego/orm"
)

type ServerGroup struct {
	Id          int
	CreateId    int
	UpdateId    int
	GroupName   string
	Description string
	CreateTime  int64
	UpdateTime  int64
	Status      int
}

func (t *ServerGroup) TableName() string {
	return TableName("task_server_group")
}

func (t *ServerGroup) Update(fields ...string) error {
	if t.GroupName == "" {
		return fmt.Errorf("组名不能为空")
	}
	if _, err := orm.NewOrm().Update(t, fields...); err != nil {
		return err
	}
	return nil
}

func ServerGroupAdd(obj *ServerGroup) (int64, error) {
	if obj.GroupName == "" {
		return 0, fmt.Errorf("组名不能为空")
	}
	return orm.NewOrm().Insert(obj)
}

func TaskGroupGetById(id int) (*ServerGroup, error) {
	obj := &ServerGroup{
		Id: id,
	}
	err := orm.NewOrm().Read(obj)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func ServerGroupDelById(id int) error {
	_, err := orm.NewOrm().QueryTable(TableName("task_server_group")).Filter("id", id).Delete()
	return err
}

func ServerGroupGetList(page, pageSize int, filters ...interface{}) ([]*ServerGroup, int64) {
	offset := (page - 1) * pageSize
	list := make([]*ServerGroup, 0)
	query := orm.NewOrm().QueryTable(TableName("task_server_group"))
	if len(filters) > 0 {
		l := len(filters)
		for k := 0; k < l; k += 2 {
			query = query.Filter(filters[k].(string), filters[k+1])
		}
	}
	total, _ := query.Count()
	query.OrderBy("-id").Limit(pageSize, offset).All(&list)
	return list, total
}
