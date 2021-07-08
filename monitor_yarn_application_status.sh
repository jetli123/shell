#!/bin/bash
#Program: monitor spark tasks: 
# example JoinInStreaming,WideTablePayment and WideTable
#Author
# Jetli
#History
# 2021/06/29
#
export PATH=/usr/local/jdk/bin:/usr/sbin:/usr/bin
export LANG=en_US.utf8
export LC_TIME=en_US.utf8
#
exec 3>>/tmp/monitor_spark.log
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
    cd $workdir && cd ../python/
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
    local APP='d651feba7fcb485f84a39819a17e399c'
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
# 
# get tasks status and repair
#
function get_join() {
    # define oneAlert eventid str
    local t_=`date +%s`
    yarn application -list|grep -q  JoinInStreaming
    if [ $? -eq 1 ]; then
        call_to_OneAlert "Process Alert:" "JoinInStreaming is down" "$t_"
        Sent_to_ding "Process Alert:" "JoinInStreaming is down"
        log_error "JoinInStreaming task not run."
        # dir exists or not
        hdfs dfs -ls /tmp/beamsparkrunnertest 2>/dev/null
        if [ $? -eq 0 ]; then
            hdfs dfs -rm -r /tmp/beamsparkrunnertest/
            # start process
            if [ $? -eq 0 ]; then
                cd $workdir && cd ../python/
                nohup python runBeamKafka.py &
                sleep 20
                yarn application -list|grep -q  JoinInStreaming
                if [ $? -eq 0 ]; then
                    call_to_OneAlert "Process OK:" "JoinInStreaming is down" "$t_"
                    Sent_to_ding "Process OK:" "JoinInStreaming success to startup"
                    log_info "JoinInStreaming starting..."
                else
                    Sent_to_ding "Process Alert:" "JoinInStreaming failed to startup"
                    log_info "JoinInStreaming start to failed"
                fi
            else
                log_error "/tmp/beamsparkrunnertest/ del has a error"
            fi
        else
            log_error "/tmp/beamsparkrunnertest/ dir not exists"
            cd $workdir && cd ../python/
            nohup python runBeamKafka.py &
            sleep 20
            yarn application -list|grep -q  JoinInStreaming
            if [ $? -eq 0 ]; then
                call_to_OneAlert "Process OK:" "JoinInStreaming is down" "$t_"
                Sent_to_ding "Process OK:" "JoinInStreaming success to startup"
                log_info "JoinInStreaming starting..."
            else
                Sent_to_ding "Process Alert:" "JoinInStreaming failed to startup"
                log_info "JoinInStreaming start to failed"
            fi
        fi
    fi
    
}
function get_wide() {
    # define oneAlert eventid str
    local t_=`date +%s`
    yarn application -list|grep -v "WideTablePayment" |grep -q "WideTable"
    if [ $? -eq 1 ]; then
        call_to_OneAlert "Process Alert:" "WideTable is down" "$t_"
        Sent_to_ding "Process Alert:" "WideTable is down"
        log_error "WideTable task not run."
        # dir exists or not
        hdfs dfs -ls /tmp/widetable_join3/ 2>/dev/null
        if [ $? -eq 0 ]; then
            hdfs dfs -rm -r /tmp/widetable_join3/
            # start process
            if [ $? -eq 0 ]; then
                cd $workdir && cd ../python/
                nohup python runBeamWideTable.py &
                sleep 20
                yarn application -list|grep -v "WideTablePayment" |grep -q "WideTable"
                if [ $? -eq 0 ]; then
                    call_to_OneAlert "Process OK:" "WideTable is down" "$t_"
                    Sent_to_ding "Process OK:" "WideTable success to startup"
                    log_info "WideTable starting..."
                else
                    Sent_to_ding "Process Alert:" "WideTable failed to startup"
                    log_info "WideTable start to failed"
                fi
            else
                log_error "/tmp/widetable_join3/ del has a error"
            fi
        else
            log_error "/tmp/widetable_join3/ dir not exists"
            cd $workdir && cd ../python/
            nohup python runBeamWideTable.py &
            sleep 20
            yarn application -list|grep -v "WideTablePayment" |grep -q "WideTable"
            if [ $? -eq 0 ]; then
                call_to_OneAlert "Process OK:" "WideTable is down" "$t_"
                Sent_to_ding "Process OK:" "WideTable success to startup"
                log_info "WideTable starting..."
            else
                Sent_to_ding "Process Alert:" "WideTable failed to startup"
                log_info "WideTable start to failed"
            fi
        fi
    fi
    
}
function get_TablePay() {
    # define oneAlert eventid str
    local t_=`date +%s`
    yarn application -list|grep -q "WideTablePayment"
    if [ $? -eq 1 ]; then
        call_to_OneAlert "Process Alert:" "WideTablePayment is down" "$t_"
        Sent_to_ding "Process Alert" "WideTablePayment is down"
        log_error "WideTablePayment task not run."
        # dir exists or not
        hdfs dfs -ls /tmp/widetable_pay3/ 2>/dev/null
        if [ $? -eq 0 ]; then
            hdfs dfs -rm -r /tmp/widetable_pay3/
            # start process
            if [ $? -eq 0 ]; then
                cd $workdir && cd ../python/
                nohup python runBeamPay.py &
                sleep 20
                yarn application -list|grep -q "WideTablePayment"
                if [ $? -eq 0 ]; then
                    call_to_OneAlert "Process OK:" "WideTablePayment is down" "$t_"
                    Sent_to_ding "Process OK:" "WideTablePayment success to startup"
                    log_info "WideTablePayment starting..."
                else
                    Sent_to_ding "Process Alert:" "WideTablePayment failed to startup"
                    log_info "WideTablePayment start to failed"
                fi
            else
                log_error "/tmp/widetable_pay3/ del has a error"
            fi
        else
            log_error "/tmp/widetable_pay3/ dir not exists"
            cd $workdir && cd ../python/
            nohup python runBeamPay.py &
            sleep 20
            yarn application -list|grep -q "WideTablePayment"
            if [ $? -eq 0 ]; then
                call_to_OneAlert "Process OK:" "WideTablePayment is down" "$t_"
                Sent_to_ding "Process OK:" "WideTablePayment success to startup"
                log_info "WideTablePayment starting..."
            else
                Sent_to_ding "Process Alert:" "WideTablePayment failed to startup"
                log_info "WideTablePayment start to failed"
            fi
        fi
    fi
    
}
#
# main function
#
function main() {
    get_join
    get_wide
    get_TablePay
}
#
# call
#
main
