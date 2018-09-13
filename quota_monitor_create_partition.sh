#!/bin/bash
#Program
# This is create partition that the table of quota_monitor
#Author
# Li lianjie
#History
# 2017/08/11	First release
#
PASSW=epc_oam
Partition_year=`date +%Y`
Partition_month=`date +%m`
Partition_name=`date +%Y%m`
DEBUG_LOG=/root/create_partition.log
#
#
exec 1>>${DEBUG_LOG}
#
if [ $Partition_month -le 11 ]
then
	NEXT_MONTH=$[ ${Partition_name} + 1]
	P_time=$[ $NEXT_MONTH + 1 ]01
elif [ $Partition_month -eq 12 ]
then
	NEXT_YEAR=$[ $Partition_year + 1 ]
	NEXT_MONTH=$[$NEXT_YEAR]01
	P_time=$[ $NEXT_MONTH + 1 ]01
fi
#
#get value for create partition of datetime
#
Partition_time=`mysql -uroot -p${PASSW} -s -e 'select TO_DAYS('$P_time');' 2>/dev/null`

# Connect to mysql database, create partition.
#
mysql -uroot -p$PASSW <<EOF
use epc-ices;
ALTER TABLE quota_monitor_tac ADD PARTITION (PARTITION p$NEXT_MONTH VALUES LESS THAN ($Partition_time));
ALTER TABLE quota_monitor ADD PARTITION (PARTITION p$NEXT_MONTH VALUES LESS THAN ($Partition_time));
quit
EOF
#
#if create partition success that 0,else is create false.
if [ $? -eq 0 ];then
	echo -e "[debug-log] create Partition success! }\n"
else
	echo -e "[debug-log-58] create table failed! }\n"
fi
