#!/bin/bash
#Program
#	This is kill poseidon and nsnco PID shell
#History
# 2016/07/20	JET.LI	Second	release
#
#Kill posedion PID
sh /home/nsnco/AMQ_poseidon/sh/stop.sh
sleep 10
#Start poseidon server 
sh /home/nsnco/AMQ_poseidon/sh/startup.sh
#stop nsncoAdapter process 
OPD=`ps -ef |grep nsnco.jar |grep -v grep |awk -F" " '{print $2}'`
#
for KL in $OPD
do
    kill -9 $KL
done
#
sleep 230
#
#
for(( i=0;i<9;i++ ))
do
        cd /home/nsnco/nsncoAdapter/A_adapter_ssh_680$i/bin/
        sh startup.sh
done
#
cd /home/nsnco/nsncoAdapter/A_adapter_telnet_6821/bin/
sh startup.sh
