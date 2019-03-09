#!/bin/bash
#Program
# 脱敏处理
#Author
# Jet
#History
# 2018/11/13 13:15
# stdin into /var/log/note.log
exec 1>/var/log/note.log
#
# Begin to record
echo -e "----------------Beginning---------------- \n\n#######`date +%F" "%T`#######\n"
# shell script path
cd `dirname $0`
echo `pwd`
# define variable
db_name=crm_interface  # pro database name
tb_name1=crm_details   # table name1
tb_name2=sales_amount  # table name2
db_user=root           # database username
db_pass=tescomm1q2w3e!Q@W#E   # pro database pwd
db_pass1=mysql	       # pro test database pwd
db_pass2=2ghlmcl1hblsqt # pre0 database pwd
n_container=test_mariadb # pro1 database container 
addr_pre0=39.104.140.62  # pre0 address
pw_pre0=mWaitx#blsnHeadkb7  # pre0 pwd
#CMD_PROMPT="\](\$|#)"
#
# execute shell file
#script="/usr/shell_script/1.sh"
#
# login pro2 server
ssh pro2 >/dev/null 2>&1 <<EOF
  #export tables from database
  mysqldump -u${db_user} -p${db_pass} --default-character-set=utf8 ${db_name} ${tb_name1} >/root/lilianjie/${tb_name1}.sql
  #
  #if [ "$?" -eq 0 ];then
  #    echo "export ${tb_name1} is finished."
  #fi
  mysqldump -u${db_user} -p${db_pass} --default-character-set=utf8 ${db_name} ${tb_name2} >/root/lilianjie/${tb_name2}.sql
  #
  #if [ "$?" -eq 0 ];then
  #    echo "export ${tb_name2} is finished."
  #fi
  # create mariadb container
  exit
EOF
# scp sql file from pro2 to pro1
scp pro2:/root/lilianjie/${tb_name1}.sql /tmp/lilianjie/
scp pro2:/root/lilianjie/${tb_name2}.sql /tmp/lilianjie/
if [ "$?" -eq 0 ];then
    echo "[52]: scp success."
fi
# create mariadb container
docker run -d --rm -it --name ${n_container} -p 9076:3306 -e MYSQL_ROOT_PASSWORD=mysql mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
if [ "$?" -eq 0 ];then
    echo "[57]: container mariadb was be created successfully."
fi
# container state, Up is OK
stat=`docker ps -a |grep test_mariadb |gawk -F" " '{print $7}'`
if [ "${stat}" == "Up" ];then
    echo "[62]: mariadb container was already be started successfully. "
fi
# copy sql file to container
docker cp /tmp/lilianjie/${tb_name1}.sql ${n_container}:/
docker cp /tmp/lilianjie/${tb_name2}.sql ${n_container}:/
sleep 10
# export sql file into mariadb container
docker exec -it ${n_container} mysql -u${db_user} -p${db_pass1} -e "CREATE DATABASE IF NOT EXISTS crm_interface DEFAULT CHARSET utf8;" 
sleep 5
docker exec -it ${n_container} mysql -u${db_user} -p${db_pass1} -e "use ${db_name};" -e "source /${tb_name1}.sql;" -e "source /${tb_name2}.sql;"
sleep 10
# update data
docker exec -it ${n_container} mysql -u${db_user} -p${db_pass1} -e "use ${db_name};" -e "update crm_details set mobile=(SELECT FLOOR(13000000000+ RAND() * 1000000000));" -e "update sales_amount set userName=(select left(uuid(),8));" -e "update sales_amount set money=(SELECT FLOOR(100+ RAND() * 100000));"
#
# export data
docker exec -it ${n_container} mysqldump -u${db_user} -p${db_pass1} --default-character-set=utf8 ${db_name} ${tb_name1} >/root/${tb_name1}.sql
docker exec -it ${n_container} mysqldump -u${db_user} -p${db_pass1} --default-character-set=utf8 ${db_name} ${tb_name2} >/root/${tb_name2}.sql
#
# copy file from mairadb container to pro1
#docker cp ${n_container}:/root/${tb_name1}.sql /root/lilianjie/
#docker cp ${n_container}:/root/${tb_name2}.sql /root/lilianjie/
#
sleep 5
#
# copy sql file to pre0
/usr/bin/expect /usr/shell_script/CRM_interface/copy-sql2-pre0.exp
sleep 10
if [ "$?" -eq 0 ];then
    echo "[90]: expect excute success."
fi
# copy file into mariadb container in the pre0 server
/usr/bin/expect /usr/shell_script/CRM_interface/copy-sql2-mariadb-exec.exp
#
# delete pro1 sql file
rm -f /root/${tb_name1}.sql  && rm -f /root/${tb_name2}.sql
#
rm -f /tmp/lilianjie/${tb_name1}.sql  && rm -f /tmp/lilianjie/${tb_name2}.sql
#
# delete test_mariadb container
id=`docker ps -a |grep test_mariadb |gawk -F" " '{print $1}'`
docker stop $id
if [ "$?" -eq 0 ];then
    echo "[104]: ${n_container} is stop."
fi
# delete sql files on the pro2 server
ssh pro2 >/dev/null 2>&1 <<EOF
    rm -f /root/lilianjie/${tb_name1}.sql
    rm -f /root/lilianjie/${tb_name2}.sql
    exit
EOF
# End to record
echo -e "----------------End---------------- \n\n#######`date +%F" "%T`#######\n"
