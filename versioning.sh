#!/bin/bash

# Install git + svn and does some basic configuration

set -e

if [ "$#" != "2" ] ; then
    echo "Usage: versioning.sh FullName email@example.com"
    exit 1
fi

username=$1
email=$2

apt-get install git
apt-get install subversion

git config --global user.name "$username"
git config --global user.email $email

