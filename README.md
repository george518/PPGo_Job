PPGo_Job定时任务管理系统 V2.x
====

![](http://www.haodaquan.com/Uploads/article/2018-07-26/153262059813931.png)

PPGo_Job是一款定时任务可视化的、多人多权限的管理系统，采用golang开发，安装方便，资源消耗少，支持大并发，可同时管理多台服务器上的定时任务。

前言：PPGo_Job V1.x版本开源两年多了，不少朋友的公司都在用，反响还不错，当然，也有好多朋友提了不少合理的意见和建议，所以这次干脆重构了一下，连UI也重新编码。目前V2.x版本
已经用于生产环境。

码云地址：https://gitee.com/georgehao/PPGo_Job
Github地址:https://github.com/george518/PPGo_Job

文档地址：http://www.haodaquan.com/topics/1###
Wiki:https://github.com/george518/PPGo_Job/wiki


V1.x版本是一个简单的定时任务管理系统，进入V1.0 ：https://github.com/george518/PPGo_Job/releases/tag/v1.2.1
相对于V1.x版本，V2.0新增以下功能和特性：

- 1、全新UI,基于LayUI2.3构建全新页面，后端模板手工搭建，让操作更加人性化。后台模板地址：https://github.com/george518/PP_admin-template
- 2、新增权限管理功能，根据菜单权限、操作权限和数据权限进行划分，方便多用户多权限管理定时任务。
- 3、新增服务器复制功能，让服务器资源添加更加方便。
- 4、新增定时任务详情页面，将任务相关操作更加集中起来操作。
- 5、新增任务审核功能，提高任务的管控能力。
- 6、新增禁止命令管理功能，配合任务审核功能，提高任务运行安全性，总有人会犯错。
- 7、优化日志详情页面，查看日志更方便，你想看到的现场内容都在，亲。
- 8、支持docker化部署，这年头，系统不支持docker化部署好像不能出门似的。
- 9、支持windows系统运行定时系统，不歧视windows，也要支持。
- 10、提醒信息新增钉钉和微信通知功能，并支持编辑通知模版功能。让提醒内容个性化，不再死板。
- 11、新增创建、启动、关闭任务的API，通过接口的方式控制定时任务，猜你喜欢。

总之，管理定时任务，使用PPGo_Job吧，节省出来的时间，或皮或浪，随你，哈哈。

感觉不错的话，给个星星吧 ：）

也可以请我喝水
----
![github](https://github.com/george518/PP_blog/blob/master/static/public/images/weixin.png?raw=true "github")

先看效果
----
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/1-index.png?raw=true "github")
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/2-task.png?raw=true "github")
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/3-task_detail.png?raw=true "github")
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/10-auth.png?raw=true "github")
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/11-role.png?raw=true "github")
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/12-role_add.png?raw=true "github")
![image](https://github.com/linxiaozhi/PPGo_Job/blob/master/assets/screenshot/15.log.png?raw=true "github")


安装方法
----

方法一、 编译安装

- go get github.com/george518/PPGo_Job
- 创建mysql数据库，并将ppgo_job2.sql导入
- 修改config 配置数据库
- 运行 go build
- 运行 ./run.sh start|stop

mac
- 运行 ./package.sh -a amd64 -p darwin -v v2.x.0

linux
- 运行 ./package.sh -a 386 -p linux -v v2.x.0
- 运行 ./package.sh -a amd64 -p linux -v v2.x.0

windows
- 运行 ./package.sh -a amd64 -p windows -v v2.x.0


方法二、直接使用

linux

- 进入 https://github.com/george518/PPGo_Job/releases
- 下载 ppgo_job-linux-2.x.0.zip 并解压
- 进入文件夹，设置好数据库(创建数据库，导入ppgo_job2.sql)和配置文件(conf/app.conf)
- 运行 ./run.sh start|stop

mac

- 进入https://github.com/george518/PPGo_Job/releases
- 下载 ppgo_job-mac-2.x.0.zip 并解压
- 进入文件夹，设置好数据库(创建数据库，导入ppgo_job2.sql)和配置文件(conf/app.conf)
- 运行 ./run.sh start|stop

windows

- 进入 https://github.com/george518/PPGo_Job/releases
- 下载 ppgo_job-windows-2.x.0.zip 并解压
- 进入文件夹，设置好数据库(创建数据库，导入ppgo_job2.sql)和配置文件(conf/app.conf)
- 运行 run.bat

----
前台访问：http://your_host:8080
用户名：admin 密码：123456

配置文件
----
根据自己的情况修改数据库和启动端口
```
appname = PPGo_Job2
httpport = 8080
runmode = dev

version= V2.2

# 允许同时运行的任务数
jobs.pool = 1000

# 站点名称
site.name = 定时任务管理器

#通知方式 0=邮件，1=信息，2=钉钉，3=微信
notify.type = 0

# 数据库配置
db.host = 127.0.0.1
db.user = root
db.password = "123456"
db.port = 3306
db.name = ppgo_job2
db.prefix = pp_
db.timezone = Asia/Shanghai

# 邮件通知配置
email.host = smtp.mxhichina.com
email.port = 25
email.from = ci@xxx.cn
email.user = ci@xxx.cn
email.password = "xxxxxx"
email.pool = 10

# 短信通知方式配置
msg.url = http://chanxiyou.com/api/tools/send_sms
msg.pool = 10

# 钉钉通知配置
dingtalk.url = "https://oapi.dingtalk.com/robot/send?access_token=%s"
dingtalk.pool = 10

# 微信通知方式配置
wechat.url = http://xx.com/api/tools/send_wechat
wechat.pool = 10
```

编译安装-可能会遇到的问题
----
go build 时遇到以下错误：
jobs/job.go:19:2: cannot find package "golang.org/x/crypto/ssh" in any of:

需要 git clone https://github.com/golang/crypto.git
并拷贝到 $GOPATH/src/golang.org/x/ 下就OK

或

git clone https://github.com/golang/crypto.git $GOPATH/src/golang.org/x/crypto

# Docker
本地编译好的2进制文件放在根目录下执行下面的命令即可拥有
```bash
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build
```

```
docker-compose up -d

#日志查看
docker-compose logs -f web

```
# Windows远程执行

1.开启telnet功能

控制面板->程序和功能->打开或关闭Windows功能，选择Telnet服务端和Telnet客户端

2.启动telnet服务

控制面板->管理工具->服务->Telnet->启动类型改为自动并启动

3.登陆授权

控制面板->管理工具->本地安全策略，在本地安全策略中，安全设置->本地策略->安全选项->网络访问:本地帐户的共享和安全模型->经典

控制面板->管理工具->本地安全策略->安全设置->本地策略->安全选项->帐户:使用空密码的本地帐户只允许进行控制台登录->已禁用

控制面板->管理工具->计算机管理->系统工具->本地用户和组->组->TelnetClients->添加用户

任务接口说明
----
三个简陋的接口，满足日常所需。

1、新增和修改任务接口 

- url：/task/apitask
- method：post 
- params：
```
id:0
create_id:4
group_id:3
task_name:测试API创建任务
description:测试
concurrent:0
server_id:2
cron_spec:*/2 * * * *
command:free -G
timeout:0
is_notify:0
notify_type:0
notify_tpl_id:0
notify_user_ids:0
```

参数含义详见数据库字段。
需要注意的是id为0为新增，大于0为修改。

2、任务启动接口
 
- url：/task/apistart
- method：post 
- params：

```
id:11
```

3、任务暂停接口

- url：／task/apipause
- method：post 
- params：
 
 ```
 id:11
 ```


注意使用 form-data的方式传参

4、返回json，status=0表示成功，其他为失败，msg是错误理由或id

```
{
    "message": 11,
    "status": 0
}
```

具体可以使用postman测试


常见操作问题
----
1、如何删除任务？

目前操作的步骤是，在非admin用户登陆情况下，编辑一下任务，此任务会到待审核任务列表中，就可以删除了。
因为删除已经审核通过的任务是敏感操作，并且认为删除任务操作执行不多，再加上列表中操作太多，所以就放到待审核任务里执行操作了。如果大家觉得需要在任务列表中添加的话，后期再做修改。

2、删除资源分组问题。

所谓的资源，其实就是执行任务的服务器或者容器。资源的分组就是给这些服务器或者容器分个类。因此，删除资源分组的时候，基于谨慎型原则，必须保证要删除的资源分组下没有服务器资源。要么删除，要么转移到其他分组下。



联系我
----
qq群号:547564773
欢迎交流，欢迎提交代码。

感谢
----
@bannerchi 
@linxiaozhi 
@gongwalker



