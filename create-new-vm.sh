#!/bin/bash
set -e

# Check correct arguments
numArgs=$#
if [ $numArgs -lt 1 ]
    then echo "Usage: create-new-vm site-domain [www-directory]"
    exit 1
fi

# Build Virtual host template
siteDomain=$1
wwwDir=""
if [ $numArgs -eq 2 ]
    then wwwDir=$2
fi

tpl=$"<VirtualHost *:80>
    DocumentRoot /var/www/${siteDomain}/www
    ServerAlias ${siteDomain}
    ServerName ${siteDomain}
<Directory /var/www/${siteDomain}/www>
    Options -Indexes FollowSymLinks MultiViews
    AllowOverride All
    Order allow,deny
    allow from all
</Directory>

ErrorLog /var/log/apache2/${siteDomain}-error.log
CustomLog /var/log/apache2/${siteDomain}-access.log combined
</VirtualHost>
"

echo "$tpl" > /etc/apache2/sites-enabled/${siteDomain}

# Create site directories and symlinks

mkdir -p /var/www/${siteDomain}
ln -s /home/ndr/devel/${siteDomain}/${wwwDir} /var/www/${siteDomain}/www
chown -R www-data /var/www/${siteDomain}
chgrp -R www-data /var/www/${siteDomain}
chmod -R u+w,g+w /var/www/${siteDomain}

# Apache restart
/etc/init.d/apache2 restart


