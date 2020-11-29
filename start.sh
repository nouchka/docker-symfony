#!/bin/bash

[ ! -f "$APACHE_PID_FILE" ] || rm -f $APACHE_PID_FILE

[ ! "$APACHE_UID" ] || usermod -u $APACHE_UID www-data
[ ! "$APACHE_GID" ] || groupmod -g $APACHE_GID www-data

##Generate apache conf with secrets from docker
APACHE_SECRETS_CONF_FILE="/etc/apache2/conf-enabled/secrets.conf"
[ ! -f "$APACHE_SECRETS_CONF_FILE" ] || rm -f $APACHE_SECRETS_CONF_FILE
if [ -d "/run/secrets/" ]; then
find /run/secrets/ -type f -maxdepth 1| while read secret
	do
		name=$(basename $secret)
		value=$(cat $secret)
		echo "SetEnv $name $value" >> $APACHE_SECRETS_CONF_FILE
	done
fi

initSf () {
	CURRENT_DIR=$(dirname $SYMFONY_DIRECTORY/$1)
	cd $CURRENT_DIR
	ENV_NAME="$(basename $CURRENT_DIR)"
	INIT_NAME="SYMFONY_INIT_${ENV_NAME,,}"
	PRE_NAME="SYMFONY_PREV_${ENV_NAME,,}"
	POST_NAME="SYMFONY_POST_${ENV_NAME,,}"
	echo $ENV_NAME
	if [ ${!PRE_NAME} ]; then
		if [ -f ${!PRE_NAME} ]; then
			chmod +x ${!PRE_NAME}
			${!PRE_NAME}
		else
			echo "File missing "${!PRE_NAME}
		fi
	fi
	if [ ${!INIT_NAME} ]; then
		if [ "$SYMFONY_ENV" == "dev" ]; then
			su www-data -c "composer install"
		elif [ "$SYMFONY_ENV" == "test" ]; then
			su www-data -c "composer install"
		else
			if [ ! -f "app/console" ]; then
				mkdir -p app/
				cd app/
				ln -s $CURRENT_DIR/bin/console console
				cd ..
			fi
			su www-data <<'EOF'
composer install --no-dev --optimize-autoloader
##composer dump-autoload --no-dev -o
php app/console cache:clear --env=$SYMFONY_ENV --no-debug
php app/console assetic:dump --env=$SYMFONY_ENV --no-debug
EOF
		fi
	fi
	if [ ${!POST_NAME} ]; then
		if [ -f ${!POST_NAME} ]; then
			chmod +x ${!POST_NAME}
			${!POST_NAME}
		else
			echo "File missing "${!POST_NAME}
		fi
	fi
	find . ! -user www-data -exec chown www-data: {} \;
}
export -f initSf

if [ "$SYMFONY_ENV" == "dev" ]; then
	echo "Env "$SYMFONY_ENV
elif [ "$SYMFONY_ENV" == "test" ]; then
	echo "Env "$SYMFONY_ENV
else
	echo "Env "$SYMFONY_ENV
	[ ! -f "$PHP_INI_DIR/php.ini-production" ] || cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
	[ ! -f "/usr/sbin/phpdismod" ] || phpdismod xdebug
fi

find $SYMFONY_DIRECTORY \! -user www-data -exec chown www-data: {} \;
cd $SYMFONY_DIRECTORY
mkdir -p /var/www/.composer
find /var/www/.composer \! -user www-data -exec chown www-data: {} \;

if [ -f "composer.json" ]; then
	initSf composer.json
else
	find . -maxdepth 2 -name 'composer.json' -exec bash -c 'initSf "$0"' {} \;
fi

if [ $1 ]; then
	exit 0
fi

/usr/sbin/apache2 -D FOREGROUND
