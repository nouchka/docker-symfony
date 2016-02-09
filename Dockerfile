FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install php5 php5-cli php5-curl curl && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY init.sh /init.sh
RUN chmod +x /init.sh

ENV SYMFONY_ENV production
ENV SYMFONY_DIRECTORY /var/www/

CMD /init.sh
