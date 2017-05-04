#!/bin/bash
#
# owncloud Backup Script
#

. /etc/backup/owncloud

set -o pipefail

cp -r /etc/owncloud ${DIR}/
