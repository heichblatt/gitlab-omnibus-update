#!/usr/bin/env bash

# update gitlab-omnibus

set -e

REDHAT_RELEASE=$(rpm -qa \*-release | grep -Ei "redhat|centos" | cut -d"-" -f3)
URL=$(curl -s https://about.gitlab.com/downloads/ \
	| grep "centos-$REDHAT_RELEASE" \
	| cut -d\" -f2
	| sed 's/<pre>curl -O //g' )
FILE=$(echo "$URL" | awk -F\/ '{print $(NF)}')
REMOTE_VERSION=$(echo "$FILE" | sed 's/\.rpm//g')
INSTALLED_VERSION=$(rpm -qa gitlab)

if [[ "$INSTALLED_VERSION" == "$REMOTE_VERSION" ]] ; then
	echo Already at newest version: "$INSTALLED_VERSION" ;
	exit 0 ;
else
	echo New Version: "$REMOTE_VERSION"
fi

gitlab-rake gitlab:backup:create
rpm -Uvh "$URL"
gitlab-ctl reconfigure