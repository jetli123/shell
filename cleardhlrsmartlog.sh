#!/bin/bash

#Program
#	This is clear dhlr-smartcheck log program

#History
# 2015/07/29	JET.LI	First release
# 2016/06/14	Jet.Li	second release
# 2016/08/08	JETLI	Third	release

#Writer and mobilephone
#	Jet.Li && 13588886666

#file_log=/home/dhlr/dhlr-smartcheck/logs/dhlrSmartCheck.log
#file_log2=dhlrSmartCheck.log
#
#
debug=/home/dhlr/clearsmartcheck.log
#
#
#A=`wc -l $file_log | cut -d ' ' -f 1`
#line1=`cat $file_log |wc -l`
#echo "处理前:日志文件$file_log2有 $line1 行数据" >>$debug
#if [ $A -le 300000 ]
#then 
#	echo "日志$file_log2行数为:$A<300000行，不做处理！" >>$debug
#
#else 
#	echo "`date +%F-%H:%M:%S` 日志文件$file_log2行数为:$A>=300000行，开始处理！" >>$debug
       # maxlines=$[A-100000]
       # express=`printf "1,%sd" $maxlines`
       # sed -i "$express"  $file_log 
#fi
#file_log3=/home/dhlr/dhlr-smartcheck/logs/dhlrSmartCheck.log
##	line2=`cat $file_log3 |wc -l`
##	echo "`date +%F-%H:%M:%S` 处理后:日志文件$file_log2有 $line2 行数据" >>$debug
#
T1=`date +%F-%H-%M-%S`
T2=`date +%F`
T3=`date +%F\ %T`
file_path=/home/dhlr/dhlr-smartcheck/logs/
Program="智能巡检"
file_log=/home/dhlr/dhlr-smartcheck/logs/dhlrSmartCheck.log
LOG=/home/dhlr/dhlr-smartcheck/logs/dhlrSmartCheck.log.$T1
LOG2=$LOG.bz2
PRO=`ps -ef |grep smart |grep java |grep -v grep |awk '{print $2}'`
#
#
if [ -z "$PRO" ]
then
	cd /home/dhlr/dhlr-smartcheck/logs/ && grep "$T2" $file_log >$LOG && bzip2 $LOG && sleep 15
	/bin/rm -f $file_log
	cd /home/dhlr/dhlr-smartcheck/ && sh startup.sh
	echo "[$T3 INFO ] - [cleardhlrsmartlog.sh:49] :backup log success: The log file info { File: $LOG2,Path: $file_path,Time: $T2,Program: $Program" >>$debug
elif [ -n "$PRO" ]
then
	cd /home/dhlr/dhlr-smartcheck/ && sh stop.sh
	cd /home/dhlr/dhlr-smartcheck/logs/ && grep "$T2" $file_log >$LOG && bzip2 $LOG && sleep 15
	/bin/rm -f $file_log
	cd /home/dhlr/dhlr-smartcheck/ && sh startup.sh
	echo "[$T3 INFO ] - [cleardhlrsmartlog.sh:58] :backup log success: The log file info { File: $LOG2,Path: $file_path,Time: $T2,Program: $Program" >>$debug
else
	echo "[$T3 ERROR ] - [cleardhlrsmartlog.sh:63] :backup log is failed!!!" >>$debug
fi
