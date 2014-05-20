FROM sshd
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install mysql-server-5.6
ADD my.cnf /etc/mysql/my.cnf
RUN (/usr/bin/mysqld_safe &); sleep 5; echo "GRANT ALL PRIVILEGES ON *.* TO root@'%';FLUSH PRIVILEGES;" | mysql

ADD create_db /usr/local/bin/create_db
RUN chmod +x /usr/local/bin/create_db

EXPOSE 3306

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Let's run the supervior
CMD env | grep _ >> /etc/environment && /usr/bin/supervisord
