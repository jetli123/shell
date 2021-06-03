#!/bin/bash
# Program:
#    backup mysql data
# Author:
#   Jetli
# history:
#   2020/05/28 v1

exec 1>/tmp/backup_mysql.log
exec 2>>/tmp/backup_mysql_error.log

declare -a IPS;
IPS[1]="10.155.66.4"
IPS[2]="10.155.66.100"
IPS[3]="10.155.184.252"

r_dom=$(( ( RANDOM % 3 ) + 1 ))
bak_ip=${IPS[$r_dom]}

D_DIR=/home/gm_data_backup/
DTIME=`date +%F-%H:%M:%S`

/home/mysql/bin/mysqldump -uroot -pddddd -S /home/mysql/status/mysql.sock --single-transaction --default-character-set=utf8 --set-gtid-purged
=OFF -R --master-data=2 --databases gm_assets gm_logs_dingding gm_users |ssh -oStrictHostKeyChecking=no root@${bak_ip}  "cat >${D_DIR}${DTIME}.sql
"

if [ $? == 0 ]; then
    echo "Success to backup database"
fi
