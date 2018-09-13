#!/bin/bash
# selection for function

function Zeropid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6800/bin/
	sh shutdown.sh
}

function Onepid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6801/bin/
	sh shutdown.sh
}
function Twopid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6802/bin/
	sh shutdown.sh
}
function Threepid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6803/bin/
	sh shutdown.sh
}
function Fourpid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6804/bin/
	sh shutdown.sh
}
function Fivepid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6805/bin/
	sh shutdown.sh
}
function Sixpid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6806/bin/
	sh shutdown.sh
}
function Sevenpid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6807/bin/
	sh shutdown.sh
}
function Eightpid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6808/bin/
	sh shutdown.sh
}
function Ninepid {
	clear
	cd /home/nsnco/nsncoAdapter/A_adapter_ssh_6809/bin/
	sh shutdown.sh
}

clear

PS3="请输入要杀掉的执行机: "

select option in "Kill 6800 adapter pid" "Kill 6801 adapter pid" \
"Kill 6802 adapter pid" "Kill 6803 adapter pid" "Kill 6804 adapter pid" "Kill 6805 adapter pid"\
 "Kill 6806 adapter pid" "Kill 6807 adapter pid" "Kill 6808 adapter pid" "Kill 6809 adapter pid" "Exit program" 
do
  case $option in
	"Exit program")
		break;;
	"Kill 6800 adapter pid")
		Zeropid;;
        "Kill 6801 adapter pid")
		Onepid;;
	"Kill 6802 adapter pid")
		Twopid;;
	"Kill 6803 adapter pid")
		Threepid;;
	"Kill 6804 adapter pid")
		Fourpid;;
	"Kill 6805 adapter pid")
		Fivepid;;
	"Kill 6806 adapter pid")
		Sixpid;;
	"Kill 6807 adapter pid")
		Sevenpid;;
	"Kill 6808 adapter pid")
		Eightpid;;
	"Kill 6809 adapter pid")
		Ninepid;;
	*)
		clear
		echo "Sorry! Please selection agin.";;
  esac
done
clear
