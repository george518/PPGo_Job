/*
* @Author: haodaquan
* @Date:   2017-08-16 12:22:37
* @Last Modified by:   haodaquan
* @Last Modified time: 2017-08-16 12:22:55
 */

package models

import (
	"fmt"
	"github.com/astaxie/beego/orm"
)

type TaskServer struct {
	Id            int
	ServerName    string
	ServerIp      string
	Port          int
	Password      string
	PrivateKeySrc string
	PublicKeySrc  string
	Type          int
	Detail        string
	CreateTime    int64
	UpdateTime    int64
	Status        int
}

func (t *TaskServer) TableName() string {
	return TableName("task_server")
}

func (t *TaskServer) Update(fields ...string) error {
	if t.ServerName == "" {
		return fmt.Errorf("服务器名不能为空")
	}
	if t.ServerIp == "" {
		return fmt.Errorf("服务器IP不能为空")
	}

	if t.Type == 0 && t.Password == "" {
		return fmt.Errorf("服务器密码不能为空")
	}

	if t.Type == 1 && t.PrivateKeySrc == "" {
		return fmt.Errorf("私钥不能为空")
	}

	if _, err := orm.NewOrm().Update(t, fields...); err != nil {
		return err
	}
	return nil
}

func TaskServerAdd(obj *TaskServer) (int64, error) {
	if obj.ServerName == "" {
		return 0, fmt.Errorf("服务器名不能为空")
	}
	return orm.NewOrm().Insert(obj)
}

func TaskServerGetById(id int) (*TaskServer, error) {
	obj := &TaskServer{
		Id: id,
	}
	err := orm.NewOrm().Read(obj)
	if err != nil {
		return nil, err
	}
	return obj, nil
}

func TaskServerDelById(id int) error {
	_, err := orm.NewOrm().QueryTable(TableName("task_server")).Filter("id", id).Delete()
	return err
}

func TaskServerGetList(page, pageSize int) ([]*TaskServer, int64) {
	offset := (page - 1) * pageSize
	list := make([]*TaskServer, 0)
	query := orm.NewOrm().QueryTable(TableName("task_server"))
	total, _ := query.Count()
	query.OrderBy("-id").Limit(pageSize, offset).All(&list)

	return list, total
}
