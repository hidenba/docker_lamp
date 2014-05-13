FROM ubuntu:14.04
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

# install apache2 + php
RUN apt-get update
RUN apt-get -y install apache2 php5 libapache2-mod-php5

# install sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd
RUN echo 'root:root' | chpasswd
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# install supervisor
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor

# ENV setup
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2

# Make port 80 accessible
EXPOSE 80
EXPOSE 22

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD init_www /usr/local/bin/init_www
RUN chmod +x /usr/local/bin/init_www

# Let's run the supervior
CMD env | grep _ >> /etc/environment && /usr/bin/supervisord
