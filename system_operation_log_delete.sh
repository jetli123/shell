#!/bin/bash
#Program
#	delete database dhlr and table
#Author
# Jetli
#History
# 2016/10/24	Forth	release

#create log file
Time_log=`date +%Y%m%d%H%M%S`
log=/root/log/system_operation_log-${Time_log}.log

#begin working
echo "Before of delete,data is: " >>${log}

#Login database; take notes that operation database information; delete data
mysql -hlocalhost -uroot -p"dhlr_oam" <<EOF
tee  $log
use dhlr
select sub_user,app_module,op_text from system_operation_log where sub_user in('admin','nokiaadmin');
select op_user,sip from unit_login_log where op_user in('admin','nokiaadmin');
select create_name,nuber_section,unit_name from user_data_log where create_name in('admin','nokiaadmin');
SELECT app_module,log_time,op_text,sip,sub_user  FROM system_operation_log WHERE sip  NOT LIKE '10.224.196%' AND sip  NOT LIKE '10.224.20%' AND sip  NOT LIKE '10.224.40%';
select * FROM unit_login_log WHERE sip NOT LIKE '10.224.20%' AND sip NOT LIKE '10.224.196%' AND sip NOT LIKE '10.224.40%';
SELECT * FROM check_operation WHERE created_by  IN('admin','nokiaadmin');
SELECT * FROM system_operation_log WHERE app_module = '用户数据查询';
SELECT * FROM audit4aoperation_log WHERE main_account IN('admin', 'nokiaadmin') AND client_ip NOT LIKE '10.224.20%' AND client_ip NOT LIKE '10.224.196%' AND client_ip NOT LIKE '10.224.40%';
delete from system_operation_log where sub_user in('admin','nokiaadmin');
delete from unit_login_log where op_user in('admin','nokiaadmin');
delete from user_data_log where create_name in('admin','nokiaadmin');
DELETE FROM system_operation_log WHERE sip  NOT LIKE '10.224.196%' AND sip  NOT LIKE '10.224.20%' AND sip  NOT LIKE '10.224.40%';
DELETE FROM unit_login_log WHERE sip NOT LIKE '10.224.20%' AND sip NOT LIKE '10.224.196%' AND sip NOT LIKE '10.224.40%';
DELETE FROM system_operation_log WHERE app_module = '用户数据查询';
DELETE FROM check_operation_result_list
 WHERE check_operation 
 IN 
 (SELECT id 
	FROM check_operation   
	WHERE created_by  
	IN('admin','nokiaadmin'));
DELETE FROM check_operation WHERE created_by  IN('admin','nokiaadmin');
DELETE FROM check_result where created_by IN('admin','nokiaadmin');
DELETE FROM audit4aoperation_log WHERE main_account IN('admin', 'nokiaadmin') AND client_ip NOT LIKE '10.224.20%' AND client_ip NOT LIKE '10.224.196%' AND client_ip NOT LIKE '10.224.40%';
notee;
quit
EOF

#select result from /tmp/delete_sql.log
echo "finish the time is `date +%F" "%H:%M:%S`" >>${log}
