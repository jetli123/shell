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
