#!/bin/bash

set -e

if [ "$#" != "1" ] ; then
    echo "Usage: samba_installer.sh sambauser"
    exit 1
fi

packages_to_install=('libcupsys2' 'samba' 'samba-common' 'smbclient')

# install all packages

for item in ${packages_to_install[*]}
do
    apt-get -y install $item || {
        echo "Cannot install $item"
        exit 1
    }
done

read -r -d '' scf <<"EOF"
[accounts]
comment = Accounts data directory
path = /data/accounts
valid users = $sambauser
public = no
writable = yes
EOF

echo "CONF:"
echo "$scf"

smbpasswd -a $sambauser 
