# Base image
FROM ubuntu:12.04
ENV REFRESHED_AT 2013-11-16

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install common packages (from http://youtu.be/1Fm3MJhQZZg)
run apt-get -y -q install aptitude sudo apt-utils ntp build-essential libc6-dev curl tzdata wget less dnsutils gzip netcat tmux unzip sysstat git vim

# set up timezone
run echo 'Etc/UTC' > /etc/timezone
run dpkg-reconfigure --frontend noninteractive tzdata

# set up locale
run locale-gen en_US.UTF-8
run update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
