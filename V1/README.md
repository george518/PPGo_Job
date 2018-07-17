PPGo_Job定时任务管理系统
====
原由：公司运行php定时任务比较多，已经无法通过crontab来进行管理：定时任务是否执行？是否按时执行？执行结果是什么？多台服务器里的定时任务怎么管理？定时任务如何排错……，为了解决以上问题，利用业余时间开发了PPGo_Job定时任务管理系统。 
目前生产环境已经无故障运行了近一年时间。   

主要特点：
----
- 1、支持本地定时任务、跨服务器管理（密码或者密钥两种方式）
- 2、支持秒级定时任务
- 3、支持复制任务，快速添加任务，支持批量启动和停止任务
- 4、定时任务日志详细（任务运行用时，执行结果等），方便任务排错
- 5、资源占用小，支持大并发
- 6、支持任务分组，常用小功能多，更方便管理定时任务
- 7、跨平台，易部署，分分钟搞定

感觉不错的话，给个星星吧 ：）
 
效果展示
----
任务界面<br/>
![github](https://github.com/george518/PPGo_Job/blob/master/V1/static/images/task.png?raw=true "github")
<br/><br/>
添加服务器界面<br/>
![github](https://github.com/george518/PPGo_Job/blob/master/V1/static/images/server.png?raw=true "github")
<br/><br/>

安装方法    
----

方法一、 编译安装

- go get github.com/george518/PPGo_Job
- 创建mysql数据库，并将ppgo_job.sql导入
- 修改config 配置数据库
- 运行 go build
- 运行 ./run.sh start|stop

方法二、直接使用

linux

- 进入 https://github.com/george518/PPGo_Job/releases
- 下载 ppgo_job-linux-1.2.1.zip 并解压
- 进入文件夹，设置好数据库(创建数据库，导入ppgo_job.sql)和配置文件(conf/app.conf)
- 运行 ./run.sh start|stop

mac

- 进入https://github.com/george518/PPGo_Job/releases
- 下载 ppgo_job-mac-1.2.1.zip 并解压
- 进入文件夹，设置好数据库(创建数据库，导入ppgo_job.sql)和配置文件(conf/app.conf)
- 运行 ./run.sh start|stop

windows

- 暂不支持


前台访问：http://your_host:8080
用户名：admin 密码：123456

配置文件
----
根据自己的情况修改数据库和启动端口
```
appname = PPGo_Job
httpport = 8080
runmode = dev

# 允许同时运行的任务数
jobs.pool = 1000

# 站点名称
site.name = 定时任务管理器

# 数据库配置
db.host = 127.0.0.1
db.user = root
db.password = "123456"
db.port = 3306
db.name = ppgo_job
db.prefix = pp_
db.timezone = Asia/Shanghai
```

编译安装-排错
----
go build 时遇到以下错误：
jobs/job.go:19:2: cannot find package "golang.org/x/crypto/ssh" in any of:

需要 git clone https://github.com/golang/crypto.git
并拷贝到 $GOPATH/src/golang.org/x/ 下就OK

感谢
----
https://github.com/lisijie/webcron.git

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

v12.1
修复远程ssh问题

