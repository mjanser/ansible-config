#!/bin/bash
#
# Build script for ddbridge module
#

lsmod | grep -q ddbridge
if [ $? -ne 0 ]; then
  systemctl stop mythbackend.service

  cd /usr/src/dddvb-0.9.28
  make clean
  make
  make install
  modprobe ddbridge
  cd -

  systemctl start mythbackend.service
fi
