# Raspberry Pi3用 Mastodon Dockerビルドツール

* Raspberry Pi3
* Docker
* /var を btrfsの外付けSSD
* ./build.sh を実行すればビルド開始
* DO\_PUSH=1 を頭につけるとPUSHする:w
* postgres:9.6-alpine, redis:4.0-alpine は ARM対応

# Raspberry PiへのDockerインストール

	$ curl https://get.docker.com/ | sh
	$ sudo sh -c 'usermod -a -G docker $SUDO_USER'
	
	再ログイン

# Docker Repository

* https://hub.docker.com/r/mamemomonga/multiarch-armhf-ruby/
* https://hub.docker.com/r/mamemomonga/multiarch-armhf-mastodon/

# 参考URL

* https://github.com/docker-library/ruby/tree/c43fef8a60cea31eb9e7d960a076d633cb62ba8d/2.4/alpine3.6/
* https://hub.docker.com/r/multiarch/alpine/tags/
* https://github.com/tootsuite/mastodon
* https://github.com/tootsuite/documentation/blob/master/Running-Mastodon/Production-guide.md
* https://hub.docker.com/\_/postgres/
* https://hub.docker.com/\_/redis/

