package routers

import (
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job2/controllers"
)

func init() {
	// 默认登录
	//beego.Router("/", &controllers.MainController{}, "*:Index")
	beego.Router("/", &controllers.LoginController{}, "*:Login")
	beego.Router("/login_in", &controllers.LoginController{}, "*:LoginIn")
	beego.Router("/login_out", &controllers.LoginController{}, "*:LoginOut")
	//beego.Router("/no_auth", &controllers.LoginController{}, "*:NoAuth")
	beego.Router("/home", &controllers.HomeController{}, "*:Index")
	beego.Router("/home/start", &controllers.HomeController{}, "*:Start")
	//beego.AutoRouter(&controllers.ApiController{})
	//beego.AutoRouter(&controllers.ApiSourceController{})
	//beego.AutoRouter(&controllers.ApiPublicController{})
	//beego.AutoRouter(&controllers.TemplateController{})
	//beego.AutoRouter(&controllers.ApiDocController{})
	//// beego.AutoRouter(&controllers.ApiMonitorController{})
	//beego.AutoRouter(&controllers.EnvController{})
	beego.AutoRouter(&controllers.TaskController{})
	beego.AutoRouter(&controllers.GroupController{})
	//资源分组管理
	beego.AutoRouter(&controllers.ServerGroupController{})
	beego.AutoRouter(&controllers.ServerController{})
	beego.AutoRouter(&controllers.BanController{})

	//权限用户相关
	beego.AutoRouter(&controllers.AuthController{})
	beego.AutoRouter(&controllers.RoleController{})
	beego.AutoRouter(&controllers.AdminController{})
	beego.AutoRouter(&controllers.UserController{})

}
