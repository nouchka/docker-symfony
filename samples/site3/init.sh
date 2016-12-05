#!/bin/bash

rm -rf /var/www/html/
chown -R www-data: /var/www
su www-data <<'EOF'
cd /var/www
symfony new site3 lts
EOF

##Regular entrypoint
/start.sh
