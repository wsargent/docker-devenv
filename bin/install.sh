#!/bin/bash

REGISTRY=internal_registry:5000
IMAGES_PATH=/vagrant/images

# Pull the external images
/vagrant/bin/update.sh

# Use latest tag
for i in $(eval echo "base appuser"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
done;

for i in $(eval echo "oracle-java7"); do
  cd $IMAGES_PATH/$i
  docker build -t="$REGISTRY/$i" .
done;
