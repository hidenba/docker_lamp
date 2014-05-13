FROM ubuntu:14.04
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
ADD my.cnf /etc/mysql/my.cnf
RUN (/usr/bin/mysqld_safe &); sleep 3; echo "GRANT ALL PRIVILEGES ON *.* TO root@'%';FLUSH PRIVILEGES;" | mysql

ADD create_db /usr/local/bin/create_db
RUN chmod +x /usr/local/bin/create_db

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
