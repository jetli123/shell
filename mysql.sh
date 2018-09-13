#!/bin/bash
Dtime=`date +%F-%H-%M-%S`
log=/tmp/mysqlrun.log

OP=`ss -lnt |grep 3306 |awk -F" " '{print $4}' |cut -d ":" -f 4`
if [ $OP -ne "3306" ];then
	echo "mysql server is stop..." >>${log}

	VER=`ss -lnt |grep 3306 |awk -F" " '{print $4}' |cut -d ":" -f 4`
	case ${VER} in

       		3306)echo "${Dtime} mysql server is OK!..." >>${log};;

         	   *)/etc/init.d/mysqld start;;
	esac


else
	echo "Yes!!!" >>${log}
fi 

#VER=`ss -lnt |grep 3306 |awk -F" " '{print $4}' |cut -d ":" -f 4`
#case ${VER} in

#       3306)echo "${Dtime} mysql server is OK!..." >>${log};;

#          *)/etc/init.d/mysqld start;;
#esac


