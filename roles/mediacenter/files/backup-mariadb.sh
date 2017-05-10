#!/bin/bash
#
# MariaDB Backup Script
#

. /etc/backup/mariadb

set -o pipefail

cleanup()
{
    find "${DIR}/" -maxdepth 1 -type f -name "*.sql*" -mtime +${ROTATE} -print0 | xargs -0 -r rm -f
}

mysql -u${USER} -p${PASS} -s -r -N -e 'SHOW DATABASES' | grep -Ev "mysql|information_schema|performance_schema"  | while read dbname
do
  TARGET_FILE=${dbname}_`date +%Y%m%d-%H%M%S`.sql

  mysqldump -u${USER} -p${PASS} --opt --flush-logs --single-transaction ${dbname} > ${DIR}/${TARGET_FILE}
  ln -s --force ${TARGET_FILE} ${DIR}/${dbname}_latest.sql
done

if [ $? -eq 0 ] ; then
    cleanup
fi