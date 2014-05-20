FROM sshd
MAINTAINER Hidekuni KAJITA <h-kajita@esm.co.jp>

RUN apt-get update

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y install memcached

EXPOSE 11211

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Let's run the supervior
CMD env | grep _ >> /etc/environment && /usr/bin/supervisord
