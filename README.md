PPGo_Job
====
定时任务管理  
代码参考自https://github.com/lisijie/webcron.git

感觉不错的话，给个星星吧 ：）

效果展示
----
任务界面<br/>
![github](https://github.com/george518/PPGo_Job/blob/master/static/images/task.png?raw=true "github")
<br/><br/>
添加服务器界面<br/>
![github](https://github.com/george518/PPGo_Job/blob/master/static/images/server.png?raw=true "github")
<br/><br/>

安装方法    
----
1、go get github.com/george518/PPGo_Job    
2、创建mysql数据库，并将ppgo_job.sql导入    
3、修改config 配置数据库    
4、运行 go build    
5、运行 ./run.sh start|stop


前台访问：http://your_host:8080
用户名：admin 密码：123456

排错
----
go build 时遇到以下错误：
jobs/job.go:19:2: cannot find package "golang.org/x/crypto/ssh" in any of:

需要 git clone https://github.com/golang/crypto.git
并拷贝到 $GOPATH/src/golang.org/x/ 下就OK

升级日志
----
v1.0
1、初始版本 本地任务的调取和执行
2、定时任务执行日志
3、定时任务执行时间

v1.1
1、优化界面
2、优化列表的登录
3、增加初始化任务

v1.2
1、新增服务器资源添加 （新增数据表pp_task_server）
2、新增远程服务器任务执行(密码验证和密钥验证登录)
3、删除邮件通知功能（pp_task删除两个有关字段）

