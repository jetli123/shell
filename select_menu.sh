#!/bin/bash

#using select in the menu

function diskspace {
	clear
	df -Th
}

function whoson {
	clear
	who
}

function memusage {
	clear
	cat /proc/meminfo
}

PS3="Enter option: "
select option in "Display disk space" "Display login on users" "Display memory usage" "Exit program"
do
	case $option in
	"Exit program")
		break;;
	"Display disk space")
		diskspace;;
	"Display login on users")
		whoson;;
	"Display memory usage")
		memusage;;			
	*)
		clear
		echo "Sorry, wrong selection";;
	esac
done
clear
