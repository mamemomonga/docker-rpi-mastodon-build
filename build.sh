#!/bin/bash
set -eux

if [ -d build ]; then echo "build directory already exists"; exit 1; fi

mkdir build
cd build

# https://github.com/docker-library/ruby/tree/c43fef8a60cea31eb9e7d960a076d633cb62ba8d/2.4/alpine3.6/
# https://hub.docker.com/r/multiarch/alpine/tags/
mkdir ruby
cd ruby
wget https://raw.githubusercontent.com/docker-library/ruby/c43fef8a60cea31eb9e7d960a076d633cb62ba8d/2.4/alpine3.6/Dockerfile
perl -i -nlpE 's#\QFROM alpine:3.6\E#FROM multiarch/alpine:armhf-v3.6#' Dockerfile
cd ..
 
# https://github.com/tootsuite/mastodon
# https://github.com/tootsuite/documentation/blob/master/Running-Mastodon/Production-guide.md
git clone https://github.com/tootsuite/mastodon.git
cd mastodon
export MASTODON_VER=$(git tag -l | grep -v 'rc[0-9]*$' | sort -V | tail -n 1)
git checkout $MASTODON_VER
patch -p1 < ../../mastodon-arm.patch
cd ..

docker build -t mamemomonga/multiarch-armhf-ruby:2.4.4-alpine3.6 ruby
docker build -t mamemomonga/multiarch-armhf-mastodon:$MASTODON_VER mastodon

if [ -n "${DO_PUSH:-}" ]; then
	docker push mamemomonga/multiarch-armhf-ruby:2.4.4-alpine3.6
	docker push mamemomonga/multiarch-armhf-mastodon:$MASTODON_VER
fi

# postgres:9.6-alpine, redis:4.0-alpine は ARM対応
# https://hub.docker.com/_/postgres/
# https://hub.docker.com/_/redis/

