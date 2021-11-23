#!/usr/bin/env bash

export IMAGE_NAME=$1

sudo docker-compose -f docker-compose.yaml up --detach

echo "success"

export TEST=testvalue
