#!/bin/bash
#Program
#	create tables for every month
#Author
# Jet.Li
#History
# 2016/10/31 14:27	First	release
# 2016/11/04 10:11	Second	release
#
now_mon=`date +%m`
now_year=`date +%Y`
now_YM=`date +%Y%m`
passw=epc_oam
log=/root/quota.debug
exec 1>>$log
#
if [ "$now_mon" -le 11 ]
then
	DAT=$[ $now_YM + 1 ]
elif [ "$now_mon" -eq 12 ]
then
	now_year=$[ $now_year + 1 ]
	DAT=$(echo $now_year01)01
fi
#
echo "[debug-log-21] begin create table. session {talbe_name:quota_monitor_$DAT ,time:`date +%F" "%T` ,log:$log }"
echo
##
mysql -uroot -p$passw <<EOF
use epc-ices;
CREATE TABLE quota_monitor_$DAT (
nthlr_id int(11) DEFAULT NULL,
nthlr_name varchar(30) DEFAULT NULL,
nthlrfe_id int(11) DEFAULT NULL,
nthlrfe_name varchar(30) DEFAULT NULL,
tag_id int(11) DEFAULT NULL,
tag_name varchar(30) DEFAULT NULL,
node varchar(40) DEFAULT NULL,
netype varchar(30) DEFAULT NULL,
kpiname varchar(30) DEFAULT NULL,
kpivalue decimal(10,2) DEFAULT NULL,
kpifailcount decimal(10,0) DEFAULT NULL,
kpirequestcount decimal(10,0) DEFAULT NULL,
period varchar(30) DEFAULT NULL,
kpiunit varchar(3) DEFAULT NULL,
scene varchar(20) DEFAULT NULL,
huan1 decimal(10,0) DEFAULT NULL,
huan2 decimal(10,0) DEFAULT NULL,
tong1 decimal(10,0) DEFAULT NULL,
tong2 decimal(10,0) DEFAULT NULL
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
quit
EOF
#
# 0 is true,else is false.
if [ "$?" -eq 0 ]
then
	echo "[debug-log-56] create table success! session {talbe_name:quota_monitor_$DAT ,time:`date +%F" "%T` ,log:$log }"
	echo
else
	echo "[debug-log-58] create table failed! session {talbe_name:quota_monitor_$DAT ,time:`date +%F" "%T` ,log:$log }"
	echo
fi
