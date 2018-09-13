#!/bin/bash
#Program
#	The shell is Kill the pid of Adapter
#
#Author		Jetli
#History
# 2016/08/16	Fouth	release
# 2016/08/24	fifth	release
#
# stop poseidon program
cd /home/nsnco/AMQ_poseidon/sh && sh stop.sh
###
OPD=`ps -ef |grep nsnco.jar |grep -v grep |awk -F" " '{print $2}'`
PID=`cat /home/nsnco/nsncoAdapter/B_adapter_ssh_6846/dapter.pid`
for KL in $OPD
do
	if [ "$KL" -eq "$PID" ];then
		continue
	fi
    kill -9 $KL
done
#### start poseidon program
sleep 10
cd /home/nsnco/AMQ_poseidon/sh && sh startup.sh
###
sleep 100
## start ssh adapter from 6840 to 6848,but not 6846 adapter for ssh
#
for(( i=0;i<9;i++ ))
do
	if [ "$i" -eq 6 ];then
		continue 
	fi
	cd /home/nsnco/nsncoAdapter/B_adapter_ssh_684$i/bin/ && sh startup.sh
done
# start telnet for 6861 
cd /home/nsnco/nsncoAdapter/B_adapter_telnet_6861/bin/
sh startup.sh
#cd /home/nsnco/nsncoAdapter/B_adapter_telnet_6860/bin/
#sh startup.sh
