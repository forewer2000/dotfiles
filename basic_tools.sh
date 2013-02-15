#!/bin/bash

set -e

packages_to_install=('ssh' 'vim-gtk' 'build-essential' 'module-assistant')

# install all packages

apt-get update
apt-get upgrade

for item in ${packages_to_install[*]}
do
    apt-get -y install $item || {
        echo "Cannot install $item"
        exit 1
    }
done


