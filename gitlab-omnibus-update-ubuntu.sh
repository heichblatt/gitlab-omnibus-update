#!/usr/bin/env bash

# update gitlab-omnibus

set -x

URL=$(curl -s https://www.gitlab.com/downloads/ | grep "a href" | grep "ubuntu-12.04" | cut -d\" -f2)
FILE=$(echo "$URL"|awk -F\/ '{print $(NF)}')
VERSION=$(echo "$FILE"|cut -d\_ -f2)
INSTALLED_VERSION=$(dpkg -s gitlab|grep Version|cut -d\: -f2|sed 's/\ //g')
if [[ "$INSTALLED_VERSION" == "$VERSION" ]] ; then
	echo Already at newest version: "$INSTALLED_VERSION" ;
	exit 0 ;
else
	echo New Version: "$VERSION"
fi

cd /usr/src
wget -c "$URL"
dpkg -i ./$FILE
gitlab-ctl reconfigure