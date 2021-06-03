#!/bin/bash
#Program
# delete master table logrecord data and one time delete limit 10000
#####################################################################################
#E.g 1.sh data_count db_passwd head_dbName db_name , when cycle=5 delete data count is 50000 and so on. ; head_dbName is cok or log, db_name is db1、db2、db345
#####################################################################################
#Author
# Jetli
#Histroy
# 2021/05/28
#
export PATH=$PATH:/usr/local/bin
export LANG=en_US.utf8
export LC_TIME=en_US.utf8

exec 3>>/tmp/delete_logrecord.log
# print log info
function log_error() {
    echo -e "\033[31m $1 \033[0m" >&3
}
function log_info() {
    echo  "$1" >&3
}
function log_waring() {
    echo -e "\033[32m $1 \033[0m" >&3
}
# set vars
data_count=$1
db_passwd=$2
head_dbName=$3
db_name=$4
#
#
function drop_data() {

    if [ -d /home/mysql ]; then
        DIR=/home/mysql
        export  PATH=/home/mysql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
    elif [ -d /home/elex/mysql ]; then
        DIR=/home/elex/mysql
        export  PATH=/home/elex/mysql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
    else
        log_error "not mysql dir."
        exit 1
    fi
    # calculate cycle count
    percen=$(( $data_count / 10000 ))
    # delete data to limit 10000
    if [ $percen -ne 0 -a $percen -ge 1 ]; then
        log_info "cycle count is $percen."
        for (( i=0;i<$percen;i++ ))
        do 
            mysql -uroot -p${db_passwd}  -S $DIR/status/mysql.sock ${head_dbName}${db_name}  -e "delete from logrecord limit 10000;"
            sleep 2
            i+=
        done
        log_info "in the ${head_dbName}${db_name} and $percen data is deleted."
    else
        log_waring "less then 10000, do not any thing."
        exit 0
    fi
}
#
main() {
    drop_data
}
#
main
