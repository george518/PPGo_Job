/************************************************************
** @Description: models
** @Author: haodaquan
** @Date:   2018-06-10 19:51
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-10 19:51
*************************************************************/
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

type Ban struct {
	Id         int
	Code       string
	CreateTime int64
	UpdateTime int64
	Status     int
}

func (t *Ban) TableName() string {
	return TableName("task_ban")
}

func (t *Ban) Update(fields ...string) error {
	if t.Code == "" {
		return fmt.Errorf("命令不能为空")
	}
	if _, err := orm.NewOrm().Update(t, fields...); err != nil {
		return err
	}
	return nil
}

func BanAdd(obj *Ban) (int64, error) {
	if obj.Code == "" {
		return 0, fmt.Errorf("命令不能为空")
	}
	return orm.NewOrm().Insert(obj)
}

func BanGetById(id int) (*Ban, error) {
	obj := &Ban{
		Id: id,
	}
	err := orm.NewOrm().Read(obj)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func BanDelById(id int) error {
	_, err := orm.NewOrm().QueryTable(TableName("task_ban")).Filter("id", id).Delete()
	return err
}

func BanGetList(page, pageSize int, filters ...interface{}) ([]*Ban, int64) {
	offset := (page - 1) * pageSize
	list := make([]*Ban, 0)
	query := orm.NewOrm().QueryTable(TableName("task_ban"))
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
