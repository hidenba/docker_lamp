FROM sshd
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise main" > /etc/apt/sources.list

# install apache2 + php
RUN apt-get update
RUN apt-get -y install apache2=2.2.22-1ubuntu1
RUN apt-get -y install php5=5.3.10-1ubuntu3
RUN apt-get -y install libapache2-mod-php5=5.3.10-1ubuntu3

# ENV setup
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2

# Make port 80 accessible
EXPOSE 80

# document root init script
ADD init_www /usr/local/bin/init_www
RUN chmod +x /usr/local/bin/init_www

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Let's run the supervior
CMD env | grep _ >> /etc/environment && /usr/bin/supervisord
