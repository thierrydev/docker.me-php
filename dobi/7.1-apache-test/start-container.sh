#!/bin/bash

##################################################################################################################
# Globale Vars
##################################################################################################################

export DOCKER_HOST_IP="$(/sbin/ip route|awk '/default/ { print $3 }')"
export MYHOSTNAME=$(hostname)
export SERVER_NAME
export RELAYHOST
export DOCUMENT_ROOT
export ALIASES
export REMOTE_IP_PROXY

##################################################################################################################
# Unable to get Full Qualified Servername Workaround
##################################################################################################################

if [ "X" != "X${SERVER_NAME}" ]
then
    echo "ServerName "${SERVER_NAME} >> /etc/apache2/apache2.conf
fi

##################################################################################################################
# POSTFIX Config
##################################################################################################################

if [ "X" != "X${MYHOSTNAME}" ]
then
	echo ${MYHOSTNAME} > /etc/mailname
	sed -i 's/'myhostname\ =.*'/'myhostname=${MYHOSTNAME}'/g' /etc/postfix/main.cf
fi

if [ "X" != "X${RELAYHOST}" ]
then
	sed -i 's/'relayhost\ =.*'/'relayhost=${RELAYHOST}'/g' /etc/postfix/main.cf
fi

/etc/init.d/postfix start

##################################################################################################################
# RemoteIp Config
##################################################################################################################

if [ "X" = "X${REMOTE_IP_PROXY}" ]
then
    export REMOTE_IP_PROXY=${DOCKER_HOST_IP}
fi

if [ "X" != "X${REMOTE_IP_PROXY}" ]
then
	sed -i 's/'RemoteIPTrustedProxy.*'/'RemoteIPTrustedProxy\ ${REMOTE_IP_PROXY}'/g' /etc/apache2/conf-available/remoteip.conf
fi

##################################################################################################################
# Apache Conf
# Document Root
##################################################################################################################

if [ "X" != "X${SERVER_NAME}" ]
then
	sed -i 's/'ServerName.*'/'ServerName\ ${SERVER_NAME}'/g' /etc/apache2/sites-available/vhost.conf
fi

# Document Root
# ATTENTION: Alternate Command delimiter '#' because the "$DOCUMENT_ROOT" hold a PATH witch Slashes
if [ "X" != "X${DOCUMENT_ROOT}" ]
then
	sed -i 's#'DocumentRoot.*'#'DocumentRoot\ ${DOCUMENT_ROOT}'#g' /etc/apache2/sites-available/vhost.conf
fi

##################################################################################################################
# Alias Config
##################################################################################################################

if [ "X" != "X${ALIASES}" ]
then
	sed -i '/Alias/d' /etc/apache2/sites-available/vhost.conf

	SaveIFS=${IFS}
	IFS=';' read -ra aliases <<< "${ALIASES}"
	IFS=${SaveIFS}

	for alias in "${aliases[@]}"; do
			sed -i "/#ALIASES/a Alias $alias" /etc/apache2/sites-available/vhost.conf
	done
fi

apache2 -D FOREGROUND
