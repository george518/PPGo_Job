FROM mysql:5.7

#设置免密登录
ENV MYSQL_ALLOW_EMPTY_PASSWORD yes

VOLUME ["/var/lib/mysql"]

RUN sed -i "s/^user.*/user = root/g" /etc/mysql/my.cnf

RUN chown -R mysql /var/lib/mysql
RUN chgrp -R mysql /var/lib/mysql

#将所需文件放到容器中
COPY .docker/db/setup.sh /var/lib/mysql/setup.sh
COPY .docker/db/ppgo_job2.sql /var/lib/mysql/ppgo_job2.sql
COPY .docker/db/privileges.sql /var/lib/mysql/privileges.sql

#设置容器启动时执行的命令
CMD ["sh", "/var/lib/mysql/setup.sh"]