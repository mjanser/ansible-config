#!/bin/bash

#
# This script can be used to clone a list of repositories hosted on Github.
# Some examples:
#
# cd ansible && init-github-projects user [username] topic:ansible ansible-
# cd firefox && init-github-projects user [username] firefox firefox-addon-
# cd web && init-github-projects user [username] topic:php php-
# cd web && init-github-projects user [username] website
# cd automation && init-github-projects org [organization] automation
#

if [ $# -lt 2 -o -z "$1" -o -z "$2" ]; then
  echo "Usage: $0 [type] [username|organization] [term] [trim]"

  exit 1
fi

TYPE=$1
USERNAME=$2
TERM=$3
TRIM=
DESTINATION=$(pwd)

if [ $# -ge 4 ]; then
  TRIM=$4
fi

BASE=https://api.github.com/search/repositories?q=
if [ "$TYPE" = "org" ]; then
  URL="${BASE}org:${USERNAME}"
else
  URL="${BASE}user:${USERNAME}"
fi
URL="${URL}+${TERM}"

curl -s -H "Accept: application/vnd.github.v3+json" $URL | jq -r ".items[] \
  | \"test ! -d $DESTINATION/\" + (.name|ltrimstr(\"$TRIM\")) + \" && git clone -q --recursive \" + .ssh_url + \" $DESTINATION/\" + (.name|ltrimstr(\"$TRIM\"))" \
  | sh
