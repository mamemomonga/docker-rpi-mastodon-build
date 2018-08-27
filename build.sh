#!/bin/bash
set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function build_ruby {
	local tagname="mamemomonga/multiarch-armhf-ruby:2.4.4-alpine3.6"
	echo "*** BUILD $tagname ***"
	mkdir -p var/ruby
	cd var/ruby
	wget https://raw.githubusercontent.com/docker-library/ruby/c43fef8a60cea31eb9e7d960a076d633cb62ba8d/2.4/alpine3.6/Dockerfile
	perl -i -nlpE 's#\QFROM alpine:3.6\E#FROM multiarch/alpine:armhf-v3.6#' Dockerfile
	run_build $tagname
	cd ../..
}

function build_node {
	local tagname=="mamemomonga/multiarch-armhf-node:8.11.4-alpine3.6"
	echo "*** BUILD $tagname ***"
	mkdir -p var/node
	cd var/node
	wget https://raw.githubusercontent.com/nodejs/docker-node/72dd945d29dee5afa73956ebc971bf3a472442f7/8/alpine/Dockerfile
	perl -i -nlpE 's#\QFROM alpine:3.6\E#FROM multiarch/alpine:armhf-v3.6#' Dockerfile
	run_build $tagname
	cd ../..
}

function build_mailcatcher {
	local tagname="mamemomonga/armhf-yappabe-mailcatcher:armhf"
	echo "*** BUILD $tagname ***"
	mkdir -p var
	cd var
	git clone https://github.com/yappabe/docker-mailcatcher
	cd docker-mailcatcher
	run_build $tagname
	cd ../..
}

function build_docker-compose {
	local docker_compose_version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.name')"
	local tagname="mamemomonga/armhf-docker-compose:$docker_compose_version"
	echo "*** BUILD $tagname ***"
	mkdir -p var
	cd var
	git clone https://github.com/docker/compose.git
	cd compose
	git checkout $docker_compose_version
	run_build $tagname
	cd ../..
}

function build_mastodon {
	# Stable
	# local mastodon_ver=$( git tag -l | grep -v 'rc[0-9]*$' | sort -V | tail -n 1 )
	# RC
	# local mastodon_ver=$( git tag -l | grep 'rc[0-9]*$' | sort -V | tail -n 1 )
	local tagname="mamemomonga/multiarch-armhf-mastodon:$mastodon_ver"
	echo "*** BUILD $tagname ***"
	mkdir -p var
	cd var
	git clone https://github.com/tootsuite/mastodon.git
	cd mastodon
	git checkout $mastodon_ver

	exit

	# patch
	patch -p1 < ../../patch/mastodon-v2.4.5-arm.patch

	run_build $tagname
}

function run_build {
	local tagname=$1
	docker build -t $tagname .
	if [ -n "${DO_PUSH:-}" ]; then
		docker push $tagname
	fi
}

build_ruby
build_node
build_mailcatcher
build_docker-compose
build_mastodon

