FROM internal_registry:5000/base:latest

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN mkdir /var/run/sshd

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install lsb-release logrotate libpopt0 cron openssh-server
RUN curl http://apt.basho.com/gpg/basho.apt.key | apt-key add -
RUN bash -c "echo deb http://apt.basho.com $(lsb_release -sc) main > /etc/apt/sources.list.d/basho.list"
RUN apt-get update

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install stanchion riak riak-cs riak-cs-control

RUN ulimit -n 4096

RUN mkdir -p /var/lib/riak

ADD ./start.sh /
ADD ./set-keys.sh /
ADD ./etc /etc

RUN sh /set-keys.sh

EXPOSE 22
EXPOSE 8000
EXPOSE 8080

CMD ["/bin/bash", "/start.sh"]
