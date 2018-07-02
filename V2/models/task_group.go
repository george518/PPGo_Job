/************************************************************
** @Description: models
** @Author: haodaquan
** @Date:   2018-06-10 22:24
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-10 22:24
*************************************************************/

package models

import (
	"fmt"

	"github.com/astaxie/beego/orm"
)

type Group struct {
	Id          int
	CreateId    int
	UpdateId    int
	GroupName   string
	Description string
	CreateTime  int64
	UpdateTime  int64
	Status      int
}

func (t *Group) TableName() string {
	return TableName("task_group")
}

func (t *Group) Update(fields ...string) error {
	if t.GroupName == "" {
		return fmt.Errorf("组名不能为空")
	}
	if _, err := orm.NewOrm().Update(t, fields...); err != nil {
		return err
	}
	return nil
}

func GroupAdd(obj *Group) (int64, error) {
	if obj.GroupName == "" {
		return 0, fmt.Errorf("组名不能为空")
	}
	return orm.NewOrm().Insert(obj)
}

func GroupGetById(id int) (*Group, error) {
	obj := &Group{
		Id: id,
	}
	err := orm.NewOrm().Read(obj)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func GroupDelById(id int) error {
	_, err := orm.NewOrm().QueryTable(TableName("task_group")).Filter("id", id).Delete()
	return err
}

func GroupGetList(page, pageSize int, filters ...interface{}) ([]*Group, int64) {
	offset := (page - 1) * pageSize
	list := make([]*Group, 0)
	query := orm.NewOrm().QueryTable(TableName("task_group"))
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
