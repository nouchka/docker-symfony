ARG  BASE_IMAGE=buster
FROM debian:${BASE_IMAGE}
LABEL maintainer docker@katagena.com
LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-symfony"

ARG PHPVERSION=7.3
ARG PHPCONF=/etc/php/${PHPVERSION}
ARG DOCKER_TAG=${PHPVERSION}
ARG PUID=1000
ARG PGID=1000
LABEL version="${DOCKER_TAG}"

ENV PUID ${PUID}
ENV PGID ${PGID}
ENV SHELL /bin/bash

ENV SYMFONY_ENV=prod \
	SYMFONY_DIRECTORY=/var/www/

ENV APACHE_RUN_USER=www-data \
	APACHE_RUN_GROUP=www-data \
	APACHE_LOG_DIR=/var/log/apache2 \
	APACHE_LOCK_DIR=/var/lock/apache2 \
	APACHE_RUN_DIR=/var/run/apache2 \
	APACHE_PID_FILE=/var/run/apache2/apache2.pid

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install \
		bash-completion \
		curl \
		unzip \
		git \
		memcached \
		apache2 \
		imagemagick \
		php${PHPVERSION} \
		php${PHPVERSION}-mysql \
		php${PHPVERSION}-pgsql \
		php${PHPVERSION}-redis \
		php${PHPVERSION}-cli \
		php${PHPVERSION}-curl \
		php${PHPVERSION}-gd \
		php${PHPVERSION}-imagick \
		php${PHPVERSION}-intl \
		php${PHPVERSION}-xdebug \
		php${PHPVERSION}-apcu \
		php${PHPVERSION}-memcached \
		libapache2-mod-php${PHPVERSION} && \
	[ "$PHPVERSION" != "5" ] || apt-get -yq install php${PHPVERSION}-memcache && \
	[ "$PHPVERSION" != "5" ] || ln -s /usr/sbin/php5dismod /usr/sbin/phpdismod && \
	[ "$PHPVERSION" == "5" ] || apt-get -yq install php${PHPVERSION}-pdo-sqlite libnghttp2-dev php-memcache php${PHPVERSION}-xml php-mbstring zip librsvg2-2 && \
	[ "$PHPVERSION" == "7.3" ] || apt-get -yq install php${PHPVERSION}-mcrypt && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	a2enmod rewrite && \
	a2enmod macro && \
	a2enmod proxy && \
	a2enmod ssl && \
	a2enmod proxy_http && \
	a2dissite 000-default && \
	usermod -u ${PUID} www-data && \
	groupmod -g ${PGID} www-data && \
	usermod -s /bin/bash www-data && \
	mkdir -p /var/www/.composer && \
	chown -R www-data: /var/www && \
	echo "date.timezone = UTC" >> ${PHPCONF}/cli/php.ini && \
	echo "date.timezone = UTC" >> ${PHPCONF}/apache2/php.ini && \
	sed -i 's/session.save_handler = files/session.save_handler = redis/g' ${PHPCONF}/apache2/php.ini &&\
	echo 'session.save_path = tcp://redis:6379' >> ${PHPCONF}/apache2/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
	php /usr/local/bin/composer self-update && \
	curl -sS https://get.symfony.com/cli/installer | bash && \
	mv /root/.symfony/bin/symfony /usr/local/bin/symfony && \
	chmod a+x /usr/local/bin/symfony && \
	curl http://get.sensiolabs.org/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer && \
	chmod a+x /usr/local/bin/php-cs-fixer && \
	curl -LsS https://phar.phpunit.de/phpunit.phar  -o /usr/local/bin/phpunit && \
	chmod a+x /usr/local/bin/phpunit && \
	composer global require bamarni/symfony-console-autocomplete && \
	/root/.composer/vendor/bin/symfony-autocomplete composer > /etc/bash_completion.d/composer && \
	su - www-data -c 'echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc'

COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY check.sh /check.sh
RUN chmod +x /check.sh
HEALTHCHECK CMD /check.sh

WORKDIR /var/www

EXPOSE 80
ENTRYPOINT [ "/start.sh" ]
