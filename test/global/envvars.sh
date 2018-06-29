#!/bin/bash

echo "ME: Default ENVIRONMENT-Variablen setzen"

# Default Server ENV
export SERVER_NAME=me-base.garmisch.net

# SMTP ENV
export RELAYHOST=mx2.garmisch.net

# Apache ENV
export APACHE_DOC_ROOT=/var/www/html
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_RUN_DIR=/var/run/apache2
export APACHE_LOG_DIR=/var/log/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
export APACHE_PID_FILE=/var/run/apache2.pid
