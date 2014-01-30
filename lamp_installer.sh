#!/bin/bash

set -e

packages_to_install=('php5-cli' 'php5' 'php5-gd' 'php5-curl' 'mysql-server' 'mysql-client' 'php-pear' 'phpmyadmin' 'php5-dev' 'php-apc' 'apache2-threaded-dev' 'php5-intl')
apache_modules=('rewrite.load' 'proxy.load' 'proxy_http.load' 'headers.load' 'expires.load')



# install all packages

for item in ${packages_to_install[*]}
do
    apt-get -y install $item
done



# symlink modules

for module in ${apache_modules[*]}
do
    rm  "/etc/apache2/mods-enabled/$module" || {
        echo ""
    }

    ln -s "/etc/apache2/mods-available/$module" "/etc/apache2/mods-enabled/$module"
done

pear upgrade
pear channel-discover pear.phpunit.de
pear install --alldeps channel://pear.php.net/Net_URL2-0.3.1
pear install --alldeps channel://pear.php.net/HTTP_Request2-2.0.0RC1
pear install --alldeps phpunit/PHPUnit

service apache2 restart

sudo pecl install apc

curl -sS https://getcomposer.org/installer | php
