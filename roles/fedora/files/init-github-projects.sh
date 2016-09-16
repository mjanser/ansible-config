#!/bin/bash

#
# This script can be used to clone a list of repositories hosted on Github.
# Some examples:
#
# cd ansible && init-github-projects [username] ansible ansible
# cd firefox && init-github-projects [username] firefox firefox-addon
# cd web && init-github-projects [username] php php
# cd web && init-github-projects [username] website
#

if [ $# -lt 2 -o -z "$1" -o -z "$2" ]; then
  echo "Usage: $0 [username] [term] [trim]"

  exit 1
fi

USERNAME=$1
TERM=$2
TRIM=
DESTINATION=$(pwd)

if [ $# -ge 3 ]; then
  TRIM=$3
fi

URL=https://api.github.com/search/repositories?q=user:$USERNAME+$TERM

curl -s -H "Accept: application/vnd.github.v3+json" $URL | jq -r ".items[] \
  | \"test ! -d $DESTINATION/\" + .name + \" && git clone -q --recursive \" + .ssh_url + \" $DESTINATION/\" + (.name|ltrimstr(\"$TRIM\"))" \
  | sh
