FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install php5 php5-cli php5-curl curl git && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN php /usr/local/bin/composer self-update

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

COPY init.sh /init.sh
RUN chmod +x /init.sh

ENV SYMFONY_ENV production
ENV SYMFONY_DIRECTORY /var/www/

CMD /init.sh
