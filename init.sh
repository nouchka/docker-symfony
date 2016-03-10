#!/bin/bash

echo $SYMFONY_ENV
cd $SYMFONY_DIRECTORY

if [ ! -f "composer.json" ]; then
	cd /tmp/
	symfony new $SYMFONY_NAME
	rsync -rz /tmp/$SYMFONY_NAME/ $SYMFONY_DIRECTORY/
	cd $SYMFONY_DIRECTORY
fi

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
