#!/bin/bash
#Program This is backup MySql database shell file,and everyday to back.
#History
# 2017/03/15    Third release
#Author
#       Jet.li
#PATH=
#export PATH
#
a_time=`date "+%F-%H-%M-%S"`
a_user=root
a_passwd='dhlr_oam'
a_log=debug.out
a_backdir=databases_sql_bak
a_file1=user_data_log_$a_time.sql
a_tarfile1=$a_file1.bz2

exec 1>>debug.out
exec 3>>error.out

cd /home/

/usr/bin/mysqldump -u${a_user} -p${a_passwd} dhlr user_data_log >${a_backdir}/${a_file1} && sleep 2 && bzip2 /home/${a_backdir}/${a_file1}
#
if [ -f "$a_backdir/$a_tarfile1" ]
then
        echo "[`date +%F" "%H:%M:%S` - debug] :backup table user_data_log success!" 
	echo "[`date +%F" "%H:%M:%S` - debug] :Action End."
else
        echo "[`date +%F" "%H:%M:%S` - ERROR] :It is faild!" >&3
	echo "[`date +%F" "%H:%M:%S` - debug] :Action End." >&3
fi
sleep 3
#
mysql -hlocalhost -u${a_user} -p${a_passwd} <<EOF
use dhlr
truncate user_data_log;
quit
EOF

