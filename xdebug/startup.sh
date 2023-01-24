#!/bin/bash

NGINX_CONF=/home/default.conf
XDEBUG_CONF=/home/xdebug.ini

XDEBUG_DIR_BASE=/usr/local/etc/php/conf.d
XDEBUG_DIR_FALLBACK=/usr/local/php/etc/conf.d

if [ -f "$XDEBUG_CONF" && -f "NGINX_CONF" ]; then
    # There may be times when conf.d exists under a different directory name than expected, so we account for this
    if [ -d "$XDEBUG_DIR_BASE" ]; then
        echo "$XDEBUG_DIR_BASE exists, copying custom xdebug.ini over"
        cp "$XDEBUG_CONF" "$XDEBUG_DIR_BASE"
    elif [ ! -d "$XDEBUG_DIR_BASE" && -d "$XDEBUG_DIR_FALLBACK" ]; then
        echo "$XDEBUG_DIR_FALLBACK exists, copying custom xdebug.ini over"
        cp "$XDEBUG_CONF" "$XDEBUG_DIR_FALLBACK"
    else
        echo "Could not find conf.d directories, skipping cp."
    fi
    echo "Reloading NGINX.."
    service nginx reload
else
    echo "Config files do not exist, skipping cp."
fi