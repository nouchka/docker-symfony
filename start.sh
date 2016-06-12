#!/bin/bash

a2ensite $APACHE_VHOST

cd $SYMFONY_DIRECTORY

CONSOLE="bin/console"
if [ -f "app/console" ]; then
	CONSOLE="app/console"
fi

/usr/sbin/apache2 -D FOREGROUND
