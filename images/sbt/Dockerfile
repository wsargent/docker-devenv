FROM internal_registry:5000/oracle-java7

ENV VERSION 0.13.0
RUN wget http://repo.scala-sbt.org/scalasbt/sbt-native-packages/org/scala-sbt/sbt/$VERSION/sbt.deb

# Install the package...
RUN dpkg -i sbt.deb