PPGo_Job
====
定时任务管理  
代码参考自https://github.com/lisijie/webcron.git

安装方法    
----
1、go get github.com/george518/PPGo_Job    
2、创建mysql数据库，并将ppgo_job.sql导入    
3、修改config 配置数据库    
4、运行 go build    
5、运行 ./run.sh start|stop

前台访问：http://your_host:8080
用户名：admin 密码：123456

升级日志
----
v1.0
1、初始版本 本地任务的调取和执行
2、定时任务执行日志
3、定时任务执行时间
----
v1.1
1、优化界面
2、优化列表的登录
3、增加初始化任务
----
v1.2
1、新增服务器资源添加 （新增数据表pp_task_server）
2、新增远程服务器任务执行
3、删除邮件通知功能（pp_task删除两个有关字段）

