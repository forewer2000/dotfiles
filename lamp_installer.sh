#!/bin/bash

set -e

packages_to_install=('php5-cli' 'php5' 'php5-gd' 'php5-curl' 'mysql-server' 'mysql-client')
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

service apache2 restart

