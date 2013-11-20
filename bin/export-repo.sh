#!/bin/bash

docker export internal_registry > internal_registry.tar
gzip internal_registry.tar
mv internal_registry.tar.gz /vagrant
