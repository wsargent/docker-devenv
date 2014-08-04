# Base image
FROM phusion/baseimage:0.9.12
ENV HOME /root
ENV REFRESHED_AT 2014-07-24

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
