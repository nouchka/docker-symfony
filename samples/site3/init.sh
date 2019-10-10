#!/bin/bash

rm -rf /var/www/html/
[ ! -d "/var/www/site3/" ] || rm -rf /var/www/site3/
chown -R www-data: /var/www
su www-data <<'EOF'
cd /var/www
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
symfony local:new site3
cd site3/ && composer config extra.symfony.allow-contrib true && composer require --dev symfony/profiler-pack && composer require symfony/apache-pack
EOF

##Regular entrypoint
/start.sh
