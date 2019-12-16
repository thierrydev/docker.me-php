#!/bin/bash

set -ex

echo "###############################################"
echo "ME: install-sqlsrv"
echo "###############################################"

echo "# + install diverse Apps"
echo "-------------------------------"
apt-get install -y mysql-client

echo "# install: sqlsrv pdo_sqlsrv"
echo "-------------------------------"
export ACCEPT_EULA=Y
apt-get update \
	&& curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
	&& curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list \
	&& echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
	&& locale-gen \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install msodbcsql unixodbc-dev \
	&& docker-php-ext-install pdo pdo_mysql mysqli iconv mbstring \
	&& pecl install sqlsrv pdo_sqlsrv xdebug \
	&& docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug \
	&& a2enmod rewrite \
	&& a2dissite 000-default