#!/usr/bin/env bash

# Remove existing containers
docker stop jenkins_server
docker rm jenkins_server
docker-compose down
rm -rf docker/container

# add predfined consul config
mkdir -p runtime/docker/container/consul/data/
cp -rp src/main/docker/consul/data/ runtime/docker/container/consul/data/


## Start new containers
docker-compose up -d --build
