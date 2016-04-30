FROM nouchka/symfony
MAINTAINER Dharma Fawkes "lxc@katagena.com"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install npm && \
	ln -s /usr/bin/nodejs /usr/bin/node && \
	npm install -g bower && \
	npm install -g less && \
	npm install -g uglify-js && \
	npm install -g uglifycss
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
