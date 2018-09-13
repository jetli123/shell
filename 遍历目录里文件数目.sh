#!/bin/bash
count=0
NUM=`find /data01/home/insplt/web/sourcefile/rpt/ -name 201706211316* -print0 |xargs -0` 
for i in $NUM
do
	check=`ls $i`
	for item in $check
	do
		count=$[ $count + 1 ]
	done
	echo "$i -- $count"
	count=0
done
	

