#!/usr/bin/env bash

export IMAGE_NAME=$1

docker-compose up -d

echo "success"

export TEST=testvalue