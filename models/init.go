/*
* @Author: haodaquan
* @Date:   2017-06-20 09:44:44
* @Last Modified by:   Bee
* @Last Modified time: 2019-02-15 22:12
 */

package models

import (
	"net/url"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	_ "github.com/lib/pq"
)

var StartTime int64

func Init(startTime int64) {
	StartTime = startTime
	dbtype := beego.AppConfig.String("db.type")
	dbhost := beego.AppConfig.String("db.host")
	dbport := beego.AppConfig.String("db.port")
	dbuser := beego.AppConfig.String("db.user")
	dbpassword := beego.AppConfig.String("db.password")
	dbname := beego.AppConfig.String("db.name")
	timezone := beego.AppConfig.String("db.timezone")
	sslmode := beego.AppConfig.String("db.sslmode")

	if dbtype == "mysql" {
		if dbport == "" {
			dbport = "3306"
		}
		dsn := dbuser + ":" + dbpassword + "@tcp(" + dbhost + ":" + dbport + ")/" + dbname + "?charset=utf8"
		if timezone != "" {
			dsn = dsn + "&loc=" + url.QueryEscape(timezone)
		}
		orm.RegisterDataBase("default", "mysql", dsn)
	}else if dbtype == "postgres" {
		if dbport == "" {
			dbport = "5432"
		}
		dsn := "user="+dbuser + " password=" + dbpassword + " host=" + dbhost + " port=" + dbport + " dbname=" + dbname
		if sslmode != "" {
			dsn = dsn + " sslmode=disable"
		}
		orm.RegisterDataBase("default", "postgres", dsn)
	}

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
