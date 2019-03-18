/*
* @Author: haodaquan
* @Date:   2017-06-20 09:44:44
* @Last Modified by:   Bee
* @Last Modified time: 2019-02-15 22:12
 */

package models

import (
	"net/url"

	"fmt"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
)

var StartTime int64

func Init(startTime int64) {
	StartTime = startTime
	dbhost := beego.AppConfig.String("db.host")
	dbport := beego.AppConfig.String("db.port")
	dbuser := beego.AppConfig.String("db.user")
	dbpassword := beego.AppConfig.String("db.password")
	dbname := beego.AppConfig.String("db.name")
	timezone := beego.AppConfig.String("db.timezone")
	if dbport == "" {
		dbport = "3306"
	}
	dsn := dbuser + ":" + dbpassword + "@tcp(" + dbhost + ":" + dbport + ")/" + dbname + "?charset=utf8"
	fmt.Println(dsn)
	if timezone != "" {
		dsn = dsn + "&loc=" + url.QueryEscape(timezone)
	}
	orm.RegisterDataBase("default", "mysql", dsn)
	orm.RegisterModel(
		new(Admin),
		new(Auth),
		new(Role),
		new(RoleAuth),
		new(ServerGroup),
		new(TaskServer),
		new(Ban),
		new(Group),
		new(Task),
		new(TaskLog),
		new(NotifyTpl),
	)

	if beego.AppConfig.String("runmode") == "dev" {
		orm.Debug = true
	}
}

func TableName(name string) string {
	return beego.AppConfig.String("db.prefix") + name
}
