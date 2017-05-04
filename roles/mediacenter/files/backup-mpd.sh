#!/bin/bash
#
# MPD Backup Script
#

. /etc/backup/mpd

set -o pipefail

cleanup()
{
    find "${DIR}/" -maxdepth 1 -type f -name "*.db*" -mtime +${ROTATE} -print0 | xargs -0 -r rm -f
}

TARGET_DATE=$(date +%Y%m%d-%H%M%S)

cp /var/lib/mpd/mpd.db ${DIR}/mpd_${TARGET_DATE}.db && cp /var/lib/mpd/sticker.db ${DIR}/sticker_${TARGET_DATE}.db

if [ $? -eq 0 ] ; then
    cleanup
fi
