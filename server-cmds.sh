#!/usr/bin/env bash

export IMAGE=$1
export DOCKER_CREDS_USR=$2
export DOCKER_CREDS_PWD=$3
echo $DOCKER_CREDS_PWD | docker login -u $DOCKER_CREDS_USR --password-stdin
docker-compose -f docker-compose.yaml up --detach
echo "success"
