#!/bin/bash
#Program
#	This is backup software shell
#History
# 2016/08/02	second release
# 2016/08/16	Third	release
################# 
#               #
#Author  JetLI  #
#		#
#################
#set some variable
#
d_time=`date +%F~%H-%M-%S`
path=dhlr/
bup_dir=apache-tomcat-7.0.59/webapps/$path
bup_dir2=dhlr-smartcheck/
leave_dir=~/backup_apache_dir
log_file=/home/dhlr/dejet.log
file_name=dhlr$d_time.tar.gz
file_name2=dhlr-smartcheck$d_time.tar.gz
#
exec 1>>$log_file
#determine dir is or not exist
if [ ! -d "$leave_dir" ];then
	mkdir $leave_dir
fi
#
#begin backup software (DHLR)
echo "[ $d_time default ] - [backup.sh:23] :begin backup DHLR:"
#
cd apache-tomcat-7.0.59/webapps/
tar -zcf $leave_dir/$file_name $path 
#
#
#check the backup file that whether or not be there
if [ -f "$leave_dir/$file_name" ];then
	echo "[ $d_time  default ] - [backup.sh:31] :this is successfully: The backup file info { File: $file_name Path: $bup_dir Time: $d_time"
else
	echo "[ $d_time  default ] - [backup.sh:33] :it is fail that this backup activity:"
fi
#
#
#begin backup dhlr-smartcheck directory
echo "[ ${d_time}  default ] - [backup.sh:38] :begin backup <dhlr-smartcheck>:" 
cd /home/dhlr/
tar -zcf ${leave_dir}/${file_name2} ${bup_dir2} 
#
#
if [ -f "$leave_dir/$file_name2" ];then
	echo "[ $d_time  default ] - [backup.sh:44] :this is successfully: The backup file info { File: $file_name2 Path: $bup_dir2 Time: $d_time"
else
	echo "[ $d_time  default ] - [backup.sh:46] :it is fail that this backup activity:"
fi
#
echo "[ $d_time  default ] - [backup.sh:49] :End the backup active:"
