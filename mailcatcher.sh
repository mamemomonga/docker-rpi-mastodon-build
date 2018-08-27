#!/bin/bash
set -eux

git clone https://github.com/yappabe/docker-mailcatcher
cd docker-mailcatcher
docker build -t mamemomonga/armhf-yappabe-mailcatcher:armhf .

if [ -n "${DO_PUSH:-}" ]; then
	docker push mamemomonga/armhf-yappabe-mailcatcher
fi

