#!/usr/bin/env bash


export IMAGE_NAME=$1
docker-compose --verbose pull -f docker-compose.yaml up --detach
echo "success"
export TEST=testvalue
