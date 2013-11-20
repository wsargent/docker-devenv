#!/bin/bash

REGISTRY=internal_registry:5000
IMAGES_PATH=/vagrant/images
REPO_NAME=devenv

for dir in $IMAGES_PATH/*/
do
	cd $dir &&
	image_name=${PWD##*/} && # to assign to a variable
	echo "Pushing $image_name to $REGISTRY/$image_name" &&
	docker push $REGISTRY/$image_name
done
