#!/usr/bin/env bash

export IMAGE_NAME=$1

sudo docker-compose up -d

echo "success"

export TEST=testvalue