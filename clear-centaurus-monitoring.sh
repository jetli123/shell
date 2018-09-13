#!/bin/bash
#Program
#	clear database for centaurus that the table is tb_sys_monitoring.
#Author
# Jetli
#History
# 2016/11/24	First	release
#
#
#declare 
a_time=`date +%F" "%T`
a_passwd=dhlr_oam
a_user=root
a_mysql=`which mysql`
a_clear_log=/root/clear_monitoring.log
#outfile to file
exec 1>>$a_clear_log
#
#begin delete data
$a_mysql -u$a_user -p$a_passwd <<EOF
use centaurus;
delete from tb_sys_monitoring where DATEDIFF(SYSDATE(),loadtime) > 3;
select count(1) from tb_sys_monitoring;
quit
EOF
# if not zero then the shell is false,another is true
if [ $? -eq 0 ]
then
	echo "[ $a_time ] -.--.- [debug-mysql.clear]: Delete database data is success!"
	echo -e "\n"
else
	echo "[ $a_time ] -.--.- [debug-mysql.clear]: It is failed!"
fi
