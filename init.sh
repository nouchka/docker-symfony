#!/bin/bash

echo $SYMFONY_ENV

cd $SYMFONY_DIRECTORY

if [ ! -f "composer.json" ]; then
	cd /tmp/
	symfony new $SYMFONY_NAME
	rsync -rz /tmp/$SYMFONY_NAME/ $SYMFONY_DIRECTORY/
fi

cd $SYMFONY_DIRECTORY

if [ "$SYMFONY_ENV" == "dev" ]; then
	composer install
elif [ "$SYMFONY_ENV" == "test" ]; then
	composer install
else
	php5dismod xdebug
	composer install --no-dev --optimize-autoloader
	CONSOLE="bin/console"
	if [ -f "app/console" ]; then
		CONSOLE="app/console"
	fi
	php $CONSOLE cache:clear --env=$SYMFONY_ENV --no-debug
	php $CONSOLE assetic:dump --env=$SYMFONY_ENV --no-debug
fi
chown -R www-data: $SYMFONY_DIRECTORY
