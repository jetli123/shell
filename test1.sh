#!/bin/bash

function U1 {
	read -t10 -p "Enter login username: " NA
	if [ -n "$NA" ]
	then
		V1=`grep "$NA" 1.txt`
		if [ -n "$V1" ]
		then
			return 10
		else
			echo "Don't your name in the server."
			return 3
		fi
	else
		echo "Please enter your name!"
		return 6
	fi
}

function U2 {
	read -s -t10 -p "Enter password: " PW
	if [ -n "$PW" ]
	then
		V2=`grep "$PW" 2.txt`
		if [ -n "$V2" ]
		then
			return 20
		else
			echo "Don't your password in the server."
			return 2
		fi
	else
		echo "Please enter your password!"
		return 4
	fi	
}

U1
A1=`echo $?`
U2
A2=`echo $?`

U3=$[ $A1 + $A2 ]
if [ "$U3" -eq 30 ]
then
	echo -e "\n恭喜你,您输入的账号信息无误!"
	sleep 2
	echo -e  "Now,we will tell you that the card of bank password:"
	sleep 2
	echo "Co#mool*2334!cit"
elif [ "$U3" -eq 12 ]
then
	echo "Your password is error!"
elif [ "$U3" -eq 23 ]
then
	echo "Your name is error!"
elif [ "$U3" -eq 5 ]
then
	echo "Your name and password is all error!" 
elif [ "$U3" -eq 10 ]
then
	echo "Please enter your name and password!"
else
	echo "请再次输入用户和密码"
fi
