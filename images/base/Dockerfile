# Base image
FROM ubuntu:12.04
ENV REFRESHED_AT 2013-11-16

sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update

# Install common packages (from http://youtu.be/1Fm3MJhQZZg)
run apt-get -y -q install aptitude sudo apt-utils ntp build-essential curl tzdata wget less dnsutils gzip netcat screen unzip sysstat git python-software-properties

# set up timezone
run echo 'Etc/UTC' > /etc/timezone
run dpkg-reconfigure --frontend noninteractive tzdata

# set up locale
run locale-gen en_US.UTF-8
run update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

