#!/usr/bin/env bash

# Remove existing containers
docker stop jenkins_server
docker rm jenkins_server
docker-compose down


## Start new containers
docker-compose up -d --build
