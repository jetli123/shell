#!/bin/bash
#Program
#	testing function to kill adapter process
#Author
# 	Jetli
#History
# 2016/09/13	First	release

function adpid {
	local pid
	pid=(`echo "$@"`)
	for value in ${pid[*]}
	do
		cd /home/nsnco/nsncoAdapter/A_adapter_ssh_$value/bin/
		sh shutdown.sh
	done
}

startid() {
	local pid_1
	pid_1=(`echo "$@"`)
	for value1 in ${pid_1[*]}
	do
		cd /home/nsnco/nsncoAdapter/A_adapter_ssh_$value1/bin/
		sh startup.sh
	done
}

##shutdown adapter process
echo "Begin shutdown adapter process..."
read -t 10 -p "Enter your adapter num example 6800: " NUM1 NUM2 NUM3 NUM4 NUM5 NUM6 NUM7 NUM8 NUM9 NUM10
#adapNum=(`echo "$@"`)
adapNum=($NUM1 $NUM2 $NUM3 $NUM4 $NUM5 $NUM6 $NUM7 $NUM8 $NUM9 $NUM10)
Val=`echo ${adapNum[*]}`
adpid $Val
#
##start adapter process
echo "sleep 100 to start adapter..."
sleep 10
read -t 10 -p "Enter your adapter num example 6800: " Num1 Num2 Num3 Num4 Num5 Num6 Num7 NUm8 Num9 Num10
adapnum1=($Num1 $Num2 $Num3 $Num4 $Num5 $Num6 $Num7 $Num8 $Num9 $Num10)
Vbl=(`echo ${adapnum1[*]}`)
startid $Vbl
