#!/bin/bash

set -e

if [ "$#" != "3" ] ; then
    echo "Usage: samba_installer.sh sambauser workgroup netbiosname"
    exit 1
fi

sambauser=$1
workgroup=$2
netbios_name=$3

packages_to_install=('libcupsys2' 'samba' 'samba-common' 'smbclient')

mkdir "/home/$sambauser/devel" || {
    echo "Cannot create directory /home/$sambauser/devel or already exists"
}

chown $sambauser:www-data /home/$sambauser/devel || {
    echo "Cannot set permission to $sambauser:www-data"
    exit 1
}

chmod 0774 /home/$sambauser/devel || {
    echo "Cannot change owner for /home/$sambauser/devel"
    exit 1
}


# install all packages

for item in ${packages_to_install[*]}
do
    apt-get -y install $item || {
        echo "Cannot install $item"
        exit 1
    }
done


! read -r -d '' scf <<EOF
[global]
socket options = TCP_NODELAY IPTOS_LOWDELAY
workgroup = $workgroup
netbios name = $netbios_name
server string = %h server (Samba %v)
log file = /var/log/samba/log.%m
max log size = 1000
syslog = 0
security = user
guest account = www-data
unix extensions = no
follow symlinks = yes
wide links = yes
client lanman auth = Yes
lanman auth = Yes

[devel]
force group = www-data
path=/home/$sambauser/devel
browseable=yes
writeable=yes
guest ok = No

EOF

echo "$scf" > /etc/samba/smb.conf

smbpasswd -a $sambauser 

service smbd restart
