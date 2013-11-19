#!/bin/bash

REGISTRY=internal_registry:5000
IMAGES_PATH=/vagrant/images

# Pull the external images
/vagrant/bin/update.sh

# Use latest tag 
for i in $(eval echo "base auth"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
  docker push $REGISTRY/$i
done;

for i in $(eval echo "oracle-java7"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
  docker push $REGISTRY/$i
done;

for i in $(eval echo "sbt"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
  docker push $REGISTRY/$i
done;

for i in $(eval echo "riak-cs"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
  docker push $REGISTRY/$i
done;

for i in $(eval echo "scala"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
  docker push $REGISTRY/$i
done;

for i in $(eval echo "playframework"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
  docker push $REGISTRY/$i
done;
