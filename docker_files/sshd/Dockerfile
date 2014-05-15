FROM ubuntu:14.04
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# install sshd
RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN chmod 600 /root/.ssh/
ADD key/id_rsa.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd

# Make port 22 accessible
EXPOSE 22

# Let's run the supervior
CMD env | grep _ >> /etc/environment && /usr/sbin/sshd -D
