#!/usr/bin/env bash

# update gitlab-omnibus

set -e

URL=$(curl -s https://www.gitlab.com/downloads/ \
	| grep "a href" \
	| grep "centos" \
	| cut -d\" -f2 )
FILE=$(echo "$URL" | awk -F\/ '{print $(NF)}')
REMOTE_VERSION=$(echo "$FILE" | sed 's/\.rpm//g')
INSTALLED_VERSION=$(rpm -qa gitlab)

if [[ "$INSTALLED_VERSION" == "$REMOTE_VERSION" ]] ; then
	echo Already at newest version: "$INSTALLED_VERSION" ;
	exit 0 ;
else
	echo New Version: "$REMOTE_VERSION"
fi

#curl --progress-bar -so /usr/src/"$FILE" "$URL"
rpm -Uvh "$URL"
gitlab-ctl reconfigure