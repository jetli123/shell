#!/bin/bash

function Name {
read -p "Enter your name: " name
echo $name >>1.txt
}

function Passwd {
read -s -p "Enter your passwd: " pawd
echo $pawd >>2.txt
}

Name
sleep 2
Passwd
sleep 2
echo -e "\nCongratulation to you,the name and passwrd aleady create."
