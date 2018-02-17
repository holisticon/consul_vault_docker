#!/usr/bin/env bash

# Starts all applications. Run 'mvn docker:build' in platform and webapp before this script to create docker images.

# Remove existing containers
docker stop jenkins_server
docker rm jenkins_server
docker-compose down --rmi all
rm -rf docker/container

# add predfined consul config
mkdir -p docker/container/consul/data/
cp -rp config/consul/ docker/container/consul/data/


## Start new containers
docker-compose up -d --build

sleep 10
# unseal vault
docker exec -it vault_server vault unseal aMf3xmMkRzGJYPSCF2A534yBx4QwEGUjNbWRLoTL+pav
docker exec -it vault_server vault unseal TvK0mwG6ZSKVJEjvLMlaxjXnbZGb+QLXPu837zZO9HjN
docker exec -it vault_server vault unseal ekV/EZTBp671c66upCsUEe421sm1V7mFjYQ6Gy+GENU0

# post logs to console
docker-compose logs -f
