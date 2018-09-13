#!/bin/bash
#Program
#	This is backup MySql database shell file,and everyday to back.
#History
# 2016/07/19	Second	release
# 2017/03/15	Third release
#Author
#	Jet.li
#PATH=
#export PATH
#
a_time=`date "+%F-%H-%M-%S"`
a_passwd='dhlr_oam'
a_backdir=databases_sql_bak
a_file1=dhlr$a_time.sql
a_file2=check_subtool_result_$a_time.sql
a_file3=system_operation_log_$a_time.sql
a_file4=unit_login_log_$a_time.sql
a_user=root
a_log=debug.log
a_tarfile1=$a_file1.bz2
a_tarfile2=$a_file2.bz2
a_tarfile3=$a_file3.bz2
a_tarfile4=$a_file4.bz2
#
#Whither back is here
exec 1>>$a_log
exec 3>>/root/back.error
#
cd /home/
#
if [ ! -d $a_backdir ];then
        mkdir $a_backdir
        echo "create dir $a_backdir" 
fi
/usr/bin/mysqldump -hlocalhost -u$a_user -p$a_passwd dhlr >$a_backdir/$a_file1 && sleep 2 && bzip2 /home/$a_backdir/$a_file1
#
#tar and gzip database file
#echo result to log file
if [ -f "$a_backdir/$a_tarfile1" ];then
        echo "[`date +%F" "%H:%M:%S` - debug] :backup database dhlr success!" 
else
	echo "[`date +%F" "%H:%M:%S` - ERROR] :It is faild!" >&3
fi
#
#Delete table system_operation_log
####
/usr/bin/mysqldump  -u$a_user -p$a_passwd dhlr system_operation_log >$a_backdir/$a_file3 && sleep 2 && bzip2 /home/$a_backdir/$a_file3
#
if [ -f "$a_backdir/$a_tarfile3" ];then
        echo "[`date +%F" "%H:%M:%S` - debug] :backup table system_operation_log success!" 
else
	echo "[`date +%F" "%H:%M:%S` - ERROR] :It is faild!" >&3
fi
#
sleep 3
#
mysql -hlocalhost -u${a_user} -p${a_passwd} <<EOF
use dhlr
DELETE FROM system_operation_log WHERE DATEDIFF(SYSDATE(),log_time) > 100;
quit
EOF
##
#dalete table check_subtool_result
###
/usr/bin/mysqldump -u${a_user} -p${a_passwd} dhlr check_subtool_result >${a_backdir}/${a_file2} && sleep 2 && bzip2 /home/${a_backdir}/${a_file2}
#
if [ -f "$a_backdir/$a_tarfile2" ]
then
        echo "[`date +%F" "%H:%M:%S` - debug] :backup table check_subtool_result success!" 
else
	echo "[`date +%F" "%H:%M:%S` - ERROR] :It is faild!" >&3
fi
sleep 2
#
mysql -hlocalhost -u${a_user} -p${a_passwd} <<EOF
use dhlr
DELETE FROM check_subtool_result  WHERE DATEDIFF(SYSDATE(),CREATE_TIME) >100;
quit
EOF
#
#
#Delete table unit_login_log
#
/usr/bin/mysqldump -u${a_user} -p${a_passwd} dhlr unit_login_log >${a_backdir}/${a_file4} && sleep 2 && bzip2 /home/${a_backdir}/${a_file4} 
##
if [ -f "$a_backdir/$a_tarfile4" ]
then
        echo "[`date +%F" "%H:%M:%S` - debug] :backup table unit_login_log success!" 
else
	echo "[`date +%F" "%H:%M:%S` - ERROR] :It is faild!" >&3
fi
sleep 1
mysql -hlocalhost -u${a_user} -p${a_passwd} <<EOF
use dhlr
DELETE FROM unit_login_log WHERE DATEDIFF(SYSDATE(),START_TIME) >100;
quit
EOF
