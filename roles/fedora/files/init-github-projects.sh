#!/bin/bash

if [[ $# -eq 0 || -z "$1" ]]; then
  echo "Usage: $0 [username]"

  exit 1
fi

USERNAME=$1
DESTINATION=$(pwd)

URL=https://api.github.com/search/repositories?q=user:$USERNAME

curl -s -H "Accept: application/vnd.github.v3+json" $URL | jq ".items[] \
  | \"test ! -d $DESTINATION/\" + .name + \" && git clone -q --recursive \" + .ssh_url + \" $DESTINATION/\" + .name" \
  | sed 's/\"//g' \
  | sh
