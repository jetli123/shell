#!/bin/bash
#Program
#	This is shutdown B adapter program from while and shift and for and case loop
#Author
#	Jet.li
#History
# 2016/08/24	First	release
#PATH=
#export $PATH
#
while [ -n "$1" ]
do
	case $1 in
	6840)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;                                  
	6841)                                                    
       		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
       		sh shutdown.sh;;                                 
	6842)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;                                  
	6843)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;                                  
	6844)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;                                  
	6845)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;             
	6846)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;; 
	6847)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;                                  
	6848)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$1/bin/
		sh shutdown.sh;;                                  
	6861)                                                    
		cd /home/nsnco/nsncoAdapter/B_adapter_telnet_$1/bin/
		sh shutdown.sh;;                                  
	--) shift
		break;;
	*)
		echo "Usage: $0 6840 6841 -- 6840 6841";;
	esac
	shift
done
##
sleep 150
###
for i in $@
do
	if [ "$i"!= 6861 ]
	then
		cd /home/nsnco/nsncoAdapter/B_adapter_ssh_$i/bin/
        	sh startup.sh
	else
		cd /home/nsnco/nsncoAdapter/B_adapter_telnet_$i/bin/
		sh startup.sh
	fi
done
