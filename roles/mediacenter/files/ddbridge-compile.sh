#!/bin/bash
#
# Build script for ddbridge module
#

lsmod | grep -q ddbridge
if [ $? -ne 0 ]; then
  systemctl stop mythbackend.service

  cd /usr/src/dddvb
  make clean
  git pull
  make
  make install
  modprobe ddbridge
  cd -

  systemctl start mythbackend.service
fi
