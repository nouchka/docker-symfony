#!/bin/bash

a2ensite $APACHE_VHOST

cd $SYMFONY_DIRECTORY

CONSOLE="bin/console"
if [ -f "app/console" ]; then
	CONSOLE="app/console"
fi
php $CONSOLE doctrine:schema:update --force

/usr/sbin/apache2 -D FOREGROUND
