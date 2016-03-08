#!/bin/bash

a2ensite $APACHE_VHOST

/usr/sbin/apache2 -D FOREGROUND
