#!/usr/bin/env bash

./docker-build.sh

# post logs to console
docker-compose logs -f
