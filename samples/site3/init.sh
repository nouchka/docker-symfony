#!/bin/bash

rm -rf /var/www/html/
[ ! -d "/var/www/site3/" ] || rm -rf /var/www/site3/
chown -R www-data: /var/www
su www-data <<'EOF'
cd /var/www
symfony new site3 lts
sed -i 's/<h1>/<h1>{{ app.request.server.get("TEST_SECRET") }}/g' /var/www/site3/app/Resources/views/default/index.html.twig
sed -i 's/<h1>/<h1>{{ app.request.server.get("TEST_VARIABLE") }}/g' /var/www/site3/app/Resources/views/default/index.html.twig
EOF

##Regular entrypoint
/start.sh
