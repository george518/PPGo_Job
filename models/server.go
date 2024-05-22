/************************************************************
** @Description: models
** @Author: haodaquan
** @Date:   2018-06-09 16:11
** @Last Modified by:   haodaquan
** @Last Modified time: 2018-06-09 16:11
*************************************************************/
package models

import (
	"errors"
	"fmt"
	"github.com/astaxie/beego/orm"
	"reflect"
	"strconv"
	"strings"
)

type TaskServer struct {
	Id             int
	GroupId        int
	ConnectionType int
	ServerName     string `info:"服务器名不能为空"`
	ServerAccount  string `info:"登录账户不能为空"`
	ServerOuterIp  string
	ServerIp       string `info:"服务器IP不能为空"`
	Port           int
	Password       string
	PrivateKeySrc  string
	PublicKeySrc   string
	Type           int
	Detail         string
	CreateTime     int64
	UpdateTime     int64
	Status         int
}

func Detection(object interface{}) error {
	objectValue := reflect.ValueOf(object)
	if objectValue.Kind() == reflect.Ptr {
		objectValue = objectValue.Elem()
	}
	for i := 0; i < objectValue.NumField(); i++ {
		fieldValue := objectValue.Field(i)
		fieldType := objectValue.Type().Field(i)
		jsonTag := fieldType.Tag.Get("info")
		if jsonTag == "" {
			continue
		}
		if fieldValue.IsZero() {
			return errors.New(jsonTag)
		}
	}
	return nil
}

func (t *TaskServer) TableName() string {
	return TableName("task_server")
}

func (t *TaskServer) Update(fields ...string) error {
	err := Detection(t)
	if err != nil {
		return fmt.Errorf(err.Error())
	}
	if t.Password == "" || t.PrivateKeySrc == "" {
		switch t.Type {
		case 0:
			return errors.New("服务器密码不能为空")
		case 1:
			return errors.New("私钥不能为空")
		default:
			return errors.New("类型不在规范之内")
		}
	}

	if _, err := orm.NewOrm().Update(t, fields...); err != nil {
		return err
	}
	return nil
}

func TaskServerAdd(obj *TaskServer) (int64, error) {
	err := Detection(obj)
	if err != nil {
		return 0, fmt.Errorf(err.Error())
	}
	if obj.Password == "" || obj.PrivateKeySrc == "" {
		switch obj.Type {
		case 0:
			return 0, errors.New("服务器密码不能为空")
		case 1:
			return 0, errors.New("私钥不能为空")
		default:
			return 0, errors.New("类型不在规范之内")
		}
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

func TaskServerForActuator(serverIp string, port int) int {
	serverFilters := make([]interface{}, 0)
	serverFilters = append(serverFilters, "status__in", []int{0, 1})
	serverFilters = append(serverFilters, "server_ip", serverIp)
	serverFilters = append(serverFilters, "port", port)

	server, _ := TaskServerGetList(1, 1, serverFilters...)

	if len(server) == 1 {
		return server[0].Id
	}
	return 0
}

func TaskServerGetByIds(ids string) ([]*TaskServer, int64) {

	serverFilters := make([]interface{}, 0)
	//serverFilters = append(serverFilters, "status", 1)

	TaskServerIdsArr := strings.Split(ids, ",")
	TaskServerIds := make([]int, 0)
	for _, v := range TaskServerIdsArr {
		id, _ := strconv.Atoi(v)
		TaskServerIds = append(TaskServerIds, id)
	}
	serverFilters = append(serverFilters, "id__in", TaskServerIds)
	return TaskServerGetList(1, 1000, serverFilters...)
}

func TaskServerDelById(id int) error {
	_, err := orm.NewOrm().QueryTable(TableName("task_server")).Filter("id", id).Delete()
	return err
}

func TaskServerGetList(page, pageSize int, filters ...interface{}) ([]*TaskServer, int64) {

	offset := (page - 1) * pageSize
	list := make([]*TaskServer, 0)
	query := orm.NewOrm().QueryTable(TableName("task_server"))
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
