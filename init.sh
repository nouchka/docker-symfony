#!/bin/bash

echo $SYMFONY_ENV
cd $SYMFONY_DIRECTORY

if [ ! -f "composer.json" ]; then
	symfony new new_project
fi

if [ "$SYMFONY_ENV" == "dev" ]; then
	composer install
elif [ "$SYMFONY_ENV" == "test" ]; then
	composer install
else
	composer install --no-dev --optimize-autoloader
	php app/console cache:clear --env=$env --no-debug
	php app/console assetic:dump --env=$env --no-debug
fi
