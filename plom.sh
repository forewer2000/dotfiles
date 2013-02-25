#!/bin/bash

set -e

#plom_commands=('status' 'install' 'desinstall' 'reinstall' 'complete')



php_packages=('php5' 'php5-curl' 'php5-gd' 'php5-cli' 'php-pear')
for pack in ${php_packages[*]}
do
    ! ex=`dpkg -l | grep " $pack "`
    if [ -n "$ex" ]
    then
        echo -e "$ex" | cut -c 5-
    else
        echo -e "$pack\t\t\t\t     <<< NOT INSTALLED >>>"
    fi
done
#declare -A status



