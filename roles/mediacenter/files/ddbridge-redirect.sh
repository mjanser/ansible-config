#!/bin/bash
#
# Redirect script for ddbridge
#

sleep 8

echo "00 01" > /sys/class/ddbridge/ddbridge0/redirect
echo "01 02" > /sys/class/ddbridge/ddbridge0/redirect
