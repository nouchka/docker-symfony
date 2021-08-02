# docker-symfony
[![Docker pull](https://img.shields.io/docker/pulls/nouchka/symfony)](https://hub.docker.com/r/nouchka/symfony/)
[![Docker stars](https://img.shields.io/docker/stars/nouchka/symfony)](https://hub.docker.com/r/nouchka/symfony/)
[![Docker Automated buil](https://img.shields.io/docker/automated/nouchka/symfony.svg)](https://hub.docker.com/r/nouchka/symfony/)
[![Build Status](https://img.shields.io/travis/com/nouchka/docker-symfony/master)](https://travis-ci.com/github/nouchka/docker-symfony)
[![Docker size](https://img.shields.io/docker/image-size/nouchka/symfony/latest)](https://hub.docker.com/r/nouchka/symfony/)

# Versions

Version follows php version

* latest
* 8 (beta)
* 7.4 (latest)

# Image
This image setup a apache2/php container with composer, symfony cmd, php-cs-fixer, xdebug, memcache and imagemagick. It fixs datetime to UTC and sessions are save to redis container.

Features list :
* apache with php
* imagemagik extension
* redis extension
* xdebug extension
* pdo, pdo_mysql, pdo_pgsql
* curl, pdo_sqlite
* composer bin
* symfony bin
* bash completion for symfony
* bash completion for composer
* php-cs-fixer bin
* phpunit

Starting script :
* disable xdebug on production
* create and persist composer directory for cache
* launch init script specified by environment variable for each symfony project before init
* launch post script specified by environment variable for each symfony project after init
* make composer install if specified by environment vairable.

# Use

Use with docker compose:

	docker-compose up -d
Environment variables:

	SYMFONY_ENV=prod ##environment for symfony
	SYMFONY_DIRECTORY=/var/www ##directory of a symfony project or containing multiple symfony project
	SYMFONY_INIT_site1=True ##Launch composer install for symfony project site1
	SYMFONY_PREV_site1=./init.sh ##Launch special script before initialisation, script located in $SYMFONY_DIRECTORY/site1/
	SYMFONY_POST_site2=./launch.sh ##Launch special script after initialisation, script located in $SYMFONY_DIRECTORY/site2/

# Todo

* Use fonctionnal symfony website for docker-compose.yml, like in docker-compose.test.yml
