#!/bin/bash
#
source /etc/profile
tempfifo=$$.fifo
file_list=/tmp/file_count.txt
# step one
ls /home/db/ >$file_list
trap "exec 1000>&-; exec 1000<&- ; exit 2" 2 3 15
#
mkfifo $tempfifo
exec 1000<>$tempfifo
rm -rf $tempfifo
#
for (( i=1; i<5; i++ ))
do
    echo >&1000
done
#
############  close step one, choose below info ##########
#while [ $begin_date != $end_date ]
#do
#    read -u1000
#    {
#       echo $begin_date
#        #mysql -uroot -p"mysql" -hlocalhost  -e "use im30; create table im30_$begin_date select * from omg1;"  >>error.log 2>&1
#        { mysqldump -uroot -p"mysql" -hlocalhost im30 im30_$begin_date || exit 2; } |pv | mysql -uroot -p"mysql" $3 >>error.log 2>&1
#        echo >&1000 
#    } &
#    begin_date=`date -d "$begin_date +1 days" +"%Y%m%d"`
#done
##########################################################
while read files
do
    read -u1000
    {
        { /home/mysql/bin/mysqlbinlog /home/db/$files >/home/logs/${files##*log-bin.}.log ||exit 2 ; } ;echo >&1000
    } &
done < $file_list
#
wait
#exec 1000>&-
#
echo "done!!!!!!"
