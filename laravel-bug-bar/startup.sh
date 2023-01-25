#!/bin/bash

NGINX_CONF=/home/default.conf
XDEBUG_CONF=/home/xdebug.ini

if [ -f "$NGINX_CONF" ]; then
    cp "$NGINX_CONF" /etc/nginx/sites-available/default
    echo "Reloading NGINX.."
    service nginx reload
else
    echo "Config files do not exist, skipping cp."
fi