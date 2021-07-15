#!/bin/bash
#Program: monitor spark tasks: 
# example JoinInStreaming,WideTablePayment and WideTable
#Author
# Jetli
#History
# 2021/06/29
#
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export LANG=en_US.utf8
export LC_TIME=en_US.utf8
set -x
#
exec 3>>/tmp/monitor_kafka.log
exec 2>>/tmp/monitor_error.log
workdir=`dirname $0`
#
# define log
#
function log_info() {
    t_time=`date +%F" "%H%M%S`
    echo "$t_time: $1" >&3 
}
function log_error() {
    t_time=`date +%F" "%H%M%S`
    echo -e "\033[31m $t_time: $1 \033[0m" >&3   
}
function get_sign() {
    cd $workdir && cd python/
    secret_=`python get_ding_sign.py`
    echo $secret_
}
#
# send data to dingding
#
function Sent_to_ding() {
    local subject=$1
    local token="63ee2ce54a48d34080830d8ac450d68b4de57a2e5060e6d2c43cde41338a5e8f"
    local body=$2
    # get sign and timestamp data
    data=`get_sign`
    timestamp=`echo $data|awk '{print $1}'`
    sign=`echo $data|awk '{print $2}'`
    # sent to dingding
   # curl -H "Content-Type: application/json" -X POST -d "{
   #     \"msgtype\": \"actionCard\",
   #      \"actionCard\": {
   #          \"title\": \"$subject\",
   #          \"text\": \"#### $subject \n\n $body \n\n@所有人\",
   #          \"btnOrientation\": \"0\"
   #       }
   # }" "https://oapi.dingtalk.com/robot/send?access_token=$token&timestamp=$timestamp&sign=$sign"
    
    curl -H "Content-Type: application/json" -X POST -d "{
        \"msgtype\": \"markdown\",
        \"markdown\": {
            \"title\": \"$subject\",
            \"text\": \"#### $subject \n\n $body \n\"
        },
        \"at\": {
            \"isAtAll\": true 
        }
    }" "https://oapi.dingtalk.com/robot/send?access_token=$token&timestamp=$timestamp&sign=$sign"
}
#
# call oneAlert API
#
function call_to_OneAlert(){
    #local APP='d651feba7fcb485f84a39819a17e399c'
    local APP='952fb7bd-b336-f4e6-1169-0cedbd544e2f'
    local TITLE=$1
    local MESSAGE=$2
    local EVENTID=$3
    if echo "$1"|grep -q "OK"; then
        curl -H "Content-Type: application/json" -X POST -d"{
           \"eventType\": \"resolve\",
           \"eventId\": $EVENTID,
           \"app\": \"$APP\",
           \"priority\": 3, 
           \"alarmName\": \"进程挂了\",
           \"alarmContent\": \"$MESSAGE\",
           \"entityName\": \"$TITLE\"
        }" "http://api.onealert.com/alert/api/event/"
    else
        curl -H "Content-Type: application/json" -X POST -d"{
           \"eventType\": \"trigger\",
           \"eventId\": $EVENTID,
           \"app\": \"$APP\",
           \"priority\": 3, 
           \"alarmName\": \"进程挂了\",
           \"alarmContent\": \"$MESSAGE\",
           \"entityName\": \"$TITLE\"
        }" "http://api.onealert.com/alert/api/event/"
    fi
}
function get_kafka_host() {
    local a=`curl -s "http://10.121.93.122:9090/api/v1/query?query=kafka_server_kafkaserver_brokerstate" |jq '.data.result[0:]' |grep -oP '(?<="instance":\s").*?(?=:)' |sed ': a; N; s/\\n/ /; t a'`
    echo $a
}


function start_kafka_if_stop() {
    local all_=(10.121.70.193 10.121.70.210 10.121.93.74 10.155.114.23 10.155.114.76)
    local present_=`get_kafka_host` # 10.121.70.193 10.121.70.210 10.121.93.74 10.155.114.23 10.155.114.76
    local a_=($present_) # define array
    #local a_=(10.121.70.193 10.121.70.210 10.121.93.74 10.155.114.23) -- test---
    t_=`date +%s`
    
    for(( i=0;i<${#all_[@]};i++ )); do
        local b=0
        for(( a=0;a<${#a_[@]};a++ )); do
            if [[ "${all_[$i]}" == "${a_[$a]}" ]]; then
                b=1
                break 1
            fi
        done
        if [ $b -eq 1 ]; then
            continue
        elif [ $b -eq 0 ]; then
            call_to_OneAlert "Process Alert:" "Kafka process is down" "$t_"
            Sent_to_ding "Process Alert:" "${all_[$i]}: Kakfa process is zombie status, need restart"
            log_error "${all_[$i]} kafka process is zombie, need restart"
            Info_=`ssh -oStrictHostKeyChecking=no root@"${all_[$i]}" "ps aux |egrep -v 'ProdServerStart|grep' |grep kafka;"`
            if [ "$Info_" != "" ]; then
                PIDS=$(echo $Info_ |awk '{print $2}')
                ssh -oStrictHostKeyChecking=no root@"${all_[$i]}" "source /etc/profile && kill -s SIGKILL $PIDS && sleep 5 && cd /home/bigdata/kafka_2.11-0.10.2.0/ && bash bin/kafka-server-start.sh -daemon config/server.properties"
                sleep 20
                Info_2=`ssh -oStrictHostKeyChecking=no root@"${all_[$i]}" "ps aux |egrep -v 'ProdServerStart|grep' |grep kafka;"`
                if [ "$Info_2" != "" ]; then
                    call_to_OneAlert "Process OK:" "Kafka process is down" "$t_"
                    Sent_to_ding "Process OK:" "${all_[$i]}: Kakfa process is normal"
                    log_info "${all_[$i]} kafka process is normal"
                else
                    Sent_to_ding "Process Alert:" "${all_[$i]}: Kakfa process failed to start"
                    log_error "${all_[$i]} kafka process failed to start"
                fi
            else
                #ssh -oStrictHostKeyChecking=no root@"${all_[$i]}" "source /etc/profile && cd /home/bigdata/kafka_2.11-0.10.2.0/ && nohup bin/kafka-server-start.sh config/server.properties >>kafka_info.log 2>&1 &"
                ssh -oStrictHostKeyChecking=no root@"${all_[$i]}" "source /etc/profile && cd /home/bigdata/kafka_2.11-0.10.2.0/ && bash bin/kafka-server-start.sh  -daemon config/server.properties"
                sleep 20
                Info_3=`ssh -oStrictHostKeyChecking=no root@"${all_[$i]}" "ps aux |egrep -v 'ProdServerStart|grep' |grep kafka"`
                if [ "$Info_3" != "" ]; then
                    call_to_OneAlert "Process OK:" "Kafka process is down" "$t_"
                    Sent_to_ding "Process OK:" "${all_[$i]}: Kakfa process is normal"
                    log_info "${all_[$i]} kafka process is normal"
                else
                    Sent_to_ding "Process Alert:" "${all_[$i]}: Kakfa process failed to start"
                    log_error "${all_[$i]} kafka process failed to start"
                fi
            fi 
        fi
    done
}
#
# main function
#
function main() {
    start_kafka_if_stop
}
#
# call
#
main
