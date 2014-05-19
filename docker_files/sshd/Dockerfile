FROM ubuntu:14.04
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

RUN apt-get update
RUN apt-get install -y software-properties-common

# install sshd
RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN chmod 600 /root/.ssh/
ADD key/id_rsa.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd

# install supervisor
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make port 22 accessible
EXPOSE 22

# Let's run the supervior
CMD /usr/bin/supervisord
