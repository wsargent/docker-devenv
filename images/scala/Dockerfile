FROM internal_registry:5000/oracle-java7

ENV VERSION 2.10.3

RUN wget http://www.scala-lang.org/files/archive/scala-$VERSION.deb

RUN apt-get install -y -q libjansi-java

RUN dpkg -i scala-$VERSION.deb

