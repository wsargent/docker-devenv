#!/bin/bash

# stop and remove the existing container and image
echo "Stopping and removing internal_registry container & image:"
docker stop internal_registry
docker rm internal_registry
docker rmi samalba/docker-registry

echo "Importing from /vagrant/internal_registry.tar.gz"
sudo cat /vagrant/internal_registry.tar.gz | docker import - samalba/docker-registry

# Start up the registry again...
/vagrant/containers/internal_registry/start