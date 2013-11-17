FROM internal_registry:5000/oracle-java7

ENV VERSION 2.2.1

RUN wget http://downloads.typesafe.com/play/$VERSION/play-$VERSION.zip 

RUN unzip play-$VERSION.zip -d /opt
RUN chmod -R a+w /opt/play-$VERSION

# play port
EXPOSE 9000 

# play debug port
EXPOSE 9999
