#!/bin/bash

echo $SYMFONY_ENV

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
	##TODO desactivate php5-xdebug
	composer install --no-dev --optimize-autoloader
	php app/console cache:clear --env=$SYMFONY_ENV --no-debug
	php app/console assetic:dump --env=$SYMFONY_ENV --no-debug
fi
chown -R www-data: $SYMFONY_DIRECTORY
