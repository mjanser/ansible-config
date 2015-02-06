#!/bin/bash

sudo -u mythtv sh -c "xauth add $(xauth list $DISPLAY) && mythtv-setup; rm -rf ~/.Xauthority >/dev/null 2>&1"
