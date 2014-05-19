FROM sshd
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

RUN apt-get update

ENV LANG C.UTF-8
RUN apt-add-repository -y ppa:ondrej/mysql-5.6

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install mysql-server-5.6
ADD my.cnf /etc/mysql/my.cnf
RUN (/usr/bin/mysqld_safe &); sleep 3; echo "GRANT ALL PRIVILEGES ON *.* TO root@'%';FLUSH PRIVILEGES;" | mysql

ADD create_db /usr/local/bin/create_db
RUN chmod +x /usr/local/bin/create_db

EXPOSE 3306

CMD ["/usr/bin/mysqld_safe"]
