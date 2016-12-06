FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-symfony"
LABEL version="5"

ARG PHPVERSION=5
ARG	PHPCONF=/etc/php5

ENV SYMFONY_ENV=prod \
	SYMFONY_DIRECTORY=/var/www/

ENV APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install php${PHPVERSION}-mysql php${PHPVERSION}-redis php${PHPVERSION} php${PHPVERSION}-cli php${PHPVERSION}-curl curl git apache2 libapache2-mod-php${PHPVERSION} php${PHPVERSION}-gd imagemagick php${PHPVERSION}-imagick php${PHPVERSION}-intl php${PHPVERSION}-mcrypt php${PHPVERSION}-xdebug php${PHPVERSION}-apcu memcached php${PHPVERSION}-memcached && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
	chmod a+x /usr/local/bin/symfony

RUN curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && \
	chmod a+x /usr/local/bin/php-cs-fixer


##Apache
RUN a2enmod rewrite && \
	a2dissite 000-default && \
	usermod -u 1000 www-data && \
	groupmod -g 1000 www-data && \
	usermod -s /bin/bash www-data

##PHP date.timezone
RUN echo "date.timezone = UTC" >> ${PHPCONF}/cli/php.ini && \
	echo "date.timezone = UTC" >> ${PHPCONF}/apache2/php.ini

##in start.sh with conf on name and port
RUN sed -i 's/session.save_handler = files/session.save_handler = redis/g' ${PHPCONF}/apache2/php.ini &&\
	echo 'session.save_path = tcp://redis:6379' >> ${PHPCONF}/apache2/php.ini

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /var/www

EXPOSE 80
CMD /start.sh
