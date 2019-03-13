#!/bin/bash
#
source /etc/profile
#
tempfifo=$$.fifo
begin_date=$1
end_date=$2
table_file=/tmp/table_count.txt
#
echo "$#"
if [ "$#" -eq "3" ];then
    if [ "$begin_date" \> "$end_date" ];then
        echo "Error! $begin_date is greater than $end_date"
        exit 1
    fi
else
    echo "Error! Not enough params."
    echo "Sample: sh look_api 2019-03-08 2019-03-20 im50"
    echo " And sh look_api 1 1 im40"
    exit 1
fi
# step one
mysql -uroot -p"mysql" -P 3306 -S /var/lib/mysql/mysql.sock -B -N -e "select TABLE_NAME from information_schema.TABLES where TABLE_SCHEMA='im30';" >$table_file
#
echo "$table_file"
#
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
#	echo $begin_date
#        #mysql -uroot -p"mysql" -hlocalhost  -e "use im30; create table im30_$begin_date select * from omg1;"  >>error.log 2>&1
#        { mysqldump -uroot -p"mysql" -hlocalhost im30 im30_$begin_date || exit 2; } |pv | mysql -uroot -p"mysql" $3 >>error.log 2>&1
#        echo >&1000 
#    } &
#    begin_date=`date -d "$begin_date +1 days" +"%Y%m%d"`
#done
##########################################################
while read table
do
    read -u1000
    {
        { mysqldump -uroot -p"mysql" -hlocalhost -P 3306 im30 $table || exit2 ; } |pv | mysql -uroot -p"mysql" $3 >error.log 2>&1 ;echo >&1000
    } &
done < $table_file
#
wait
#exec 1000>&-
#
echo "done!!!!!!"
