#!/bin/bash
# Program:
# "this is get ten values"
# Auther:
#	Jetli
# History:
#	2018-09-13 15:12:00

function max {
    max=$1
    min=$2
    lin=(`echo "$@"`)
    for i in ${lin[*]}
    do
	if [ $max -lt $i ];then
	    max=$i
	fi
	if [ $min -gt $i ];then
	    min=$i
	fi
    done
	echo "$max"
	echo "$min"
}
a=`echo "$@"`
b=${a[*]}
max $b
