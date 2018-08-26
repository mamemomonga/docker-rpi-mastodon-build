#!/bin/bash
set -eux
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.name')
IMAGE_TAG="mamemomonga/armhf-docker-compose:$DOCKER_COMPOSE_VERSION"

git clone https://github.com/docker/compose.git
cd compose
git checkout $DOCKER_COMPOSE_VERSION

docker build -t $IMAGE_TAG -f Dockerfile.armhf .

if [ -n "${DO_PUSH:-}" ]; then
	docker push $IMAGE_TAG
fi

