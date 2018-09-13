#!/bin/bash

#create log file
Time_log=`date +%Y%m%d%H%M%S`
log=/root/log/delete_table_ne_operation-${Time_log}.log
tmplog=`date +%F`.log

#begin working
echo "begin execute sql that the time at `date +%F" "%H:%M:%S`" >>${log}

#Login database; take notes that operation database information; delete data
mysql -hlocalhost -uroot -p"dhlr_oam" <<EOF
use dhlr
delete from  ne_operation_log WHERE DATEDIFF(SYSDATE(),give_time)>90;
notee;
quit
EOF

#select result from /tmp/delete_sql.log
echo -e "\n" >>${log}
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >>${log}
echo "Please look up the result that operation sql to operation" >>${log}
echo "execute sql successful!Please check DHLR web server page to 网元操作日志" >>${log}
echo "finish the time is `date +%F" "%H:%M:%S`" >>${log}
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >>${log}
echo -e "\n" >>${log}
