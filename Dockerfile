ARG  BASE_IMAGE=jessie
FROM debian:${BASE_IMAGE}
LABEL maintainer docker@katagena.com
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-symfony"
LABEL version="latest"

ARG PHPVERSION=5
ARG PHPCONF=/etc/php5
ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

ENV SYMFONY_ENV=prod \
	SYMFONY_DIRECTORY=/var/www/

ENV APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install php${PHPVERSION}-mysql php${PHPVERSION}-redis php${PHPVERSION} php${PHPVERSION}-cli php${PHPVERSION}-curl curl unzip git apache2 libapache2-mod-php${PHPVERSION} php${PHPVERSION}-gd imagemagick php${PHPVERSION}-imagick php${PHPVERSION}-intl php${PHPVERSION}-mcrypt php${PHPVERSION}-xdebug php${PHPVERSION}-apcu memcached php${PHPVERSION}-memcached && \
	[ "$PHPVERSION" != "5" ] || apt-get -yq install php${PHPVERSION}-memcache && \
	[ "$PHPVERSION" != "5" ] || ln -s /usr/sbin/php5dismod /usr/sbin/phpdismod && \
	[ "$PHPVERSION" != "7.0" ] || apt-get -yq install php${PHPVERSION}-pdo-sqlite libnghttp2-dev php-memcache php${PHPVERSION}-xml php${PHPVERSION}-mbstring zip librsvg2-2 && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	a2enmod rewrite && \
	a2enmod macro && \
##	a2enmod http2 && \
	a2dissite 000-default && \
	usermod -u ${PUID} www-data && \
	groupmod -g ${PGID} www-data && \
	usermod -s /bin/bash www-data && \
	echo "date.timezone = UTC" >> ${PHPCONF}/cli/php.ini && \
	echo "date.timezone = UTC" >> ${PHPCONF}/apache2/php.ini && \
	sed -i 's/session.save_handler = files/session.save_handler = redis/g' ${PHPCONF}/apache2/php.ini &&\
	echo 'session.save_path = tcp://redis:6379' >> ${PHPCONF}/apache2/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update && \
	curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
	chmod a+x /usr/local/bin/symfony && \
	curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && \
	chmod a+x /usr/local/bin/php-cs-fixer && \
	curl -LsS https://phar.phpunit.de/phpunit.phar  -o /usr/local/bin/phpunit && \
	chmod a+x /usr/local/bin/phpunit


COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY check.sh /check.sh
RUN chmod +x /check.sh
HEALTHCHECK CMD /check.sh

WORKDIR /var/www

EXPOSE 80
CMD /start.sh
