#!/bin/bash
#Program
#       Update system id
#History
# 2016/06/22  Jet.Li First release
# 2016/07/14  Jet.Li Second release
# PATH=/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
# export $PATH
#
#check telnet Banner result
#output result into screen
#
LogFile=test.log

#check password 
#
echo "检查是否设置口令生存周期" 
TM=`date +%F-%H-%M-%S`
PAS_DAY=`grep "PASS_MAX_DAYS" /etc/login.defs |sed '/^#/d' |sed '/^$/d' |awk -F" " '{print $2}'`
if [ "$PAS_DAY" -gt 99 ];then
        cp -p /etc/login.defs  /etc/login.defs.${TM}bak
        sed -i 's/\(^PASS_MAX_DAYS.*\)/#\1/' /etc/login.defs
        echo "PASS_MAX_DAYS 90" >> /etc/login.defs
else
        echo "密码有效期：${PAS_DAY}天,不需要修改。 "
fi
echo "已设置口令生存周期：`cat /etc/login.defs |grep -i "PASS_MAX_DAYS" |sed  '/^#/d'`"
#
#
echo "检查口令最小长度"
#
PAS_LEN=`grep 'PASS_MIN_LEN' /etc/login.defs |sed '/^#/d' |sed '/^$/d' |awk -F" " '{print $2}'`
#
if [ "$PAS_LEN" -le 6 ];then
        sed -i 's/\(^PASS_MIN_LEN.*\)/#\1/' /etc/login.defs
        echo "PASS_MIN_LEN 90" >> /etc/login.defs
else    
        echo "密码长度：${PAS_LEN}>6,不需要修改。 " 
fi
#
echo "已设置口令最小长度为：`cat /etc/login.defs |grep "PASS_MIN_LEN" |sed '/^#/d'` "
##
echo "检查是否设置除root之外UID为0的用户"
#
uIO=`cat /etc/passwd |awk -F":" '$3 == 0 {print $1}'`
#
for NAME in $uIO
do
        echo "UID为0的帐号：${NAME}"
        echo "root 帐号不做操作，如果包括其他普通帐号，需要更改！"
done
#
#
echo "检查是否设置命令行界面超时退出" 
#
EXIT=`grep "TMOUT" /etc/profile |awk '{print $2}'`
if [ -z $EXIT ];then
        echo "export TMOUT=180" >>/etc/profile
	source /etc/profile
else
        echo "存在：${EXIT} 不需要修改"
fi
echo "以修改界面超时时间为：`grep "TMOUT" /etc/profile`"
#
echo "检查用户umask设置"
#
cp -p /etc/csh.cshrc /etc/csh.cshrc.bak
cp -p /etc/csh.login /etc/csh.login.bak
cp -p /etc/profile /etc/profile.bak 
cp -p /etc/bashrc /etc/bashrc.bak
#
T1=`cat /etc/profile |grep -i "umask 077" |awk '{print $1}'`
T2=`cat /etc/csh.login | grep -i "umask 077" |awk '{print $1}'`
T3=`cat /etc/csh.cshrc | grep -i "umask 077" |awk '{print $1}'`
T4=`cat /etc/bashrc | grep -i "umask 077" |awk '{print $1}'`
#
if [ -z "$T1" ];then
	echo "umask 077" >> /etc/profile
	echo "成功将umask 077加入文件中"
else
	sed -i 's/^\(umask.*\)/#\1/' /etc/profile
	echo "注释 :"`cat /etc/profile |grep -i "^#umask"`
fi
#
#
if [ -z "$T2" ];then
	echo "umask 077" >> /etc/csh.login
else
	sed -i 's/^\(umask.*\)/#\1/' /etc/csh.login
	echo "注释 :"`cat /etc/csh.login |grep -i "^#umask"`
fi
#
#
if [ -z "$T3" ];then
	echo "umask 077" >> /etc/csh.cshrc
else
	sed -i 's/^\(umask.*\)/#\1/' /etc/csh.cshrc
	echo "注释 :"`cat /etc/csh.cshrc |grep -i "^#umask"`
fi
#
#
if [ -z "$T4" ];then
	echo "umask 077" >> /etc/bashrc
else
	sed -i 's/^\(umask.*\)/#\1/' /etc/bashrc
	echo "注释 :"`cat /etc/bashrc |grep -i "^#umask"`
fi
#
#
echo "检查是否修改snmp默认团体字"
#
#
cp -p /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak
#
OBM=`cat /etc/snmp/snmpd.conf |sed '/^#/d' |sed '/^$/d' | egrep "private|public"`
#
if [ -n "$OBM" ];then
	sed -i 's/^\(.*public.*\)/#\1/' /etc/snmp/snmpd.conf
fi
echo "注释后的结果： `cat /etc/snmp/snmpd.conf | egrep "private|public"` "
#
echo "检查系统是否禁用ctrl+alt+del组合键"
#
cp -p /etc/inittab /etc/inittab.bak
#
CAD=`cat /etc/inittab |grep "ctrlaltdel" |sed '/^#/d'`
#
if [ -z "$CAD" ];then
	echo "已禁用ctrl+alt+del组合键!" 
else
	sed -i 's/^\(.*ctrlaltdel.*\)/#\1/' /etc/inittab
	echo "更改之后：" `cat /etc/inittab |grep "ctrlaltdel"`
fi
#
#
echo "检查设备密码复杂度策略" 
#
cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
#
OBBA=`egrep "ucredit|lcredit|dcredit" /etc/pam.d/system-auth |awk '{print $1}'`
#
if [ -z "$OBBA" ];then
sed -i 's/^\(password.*pam_cracklib.so\)/& ucredit=-1 lcredit=-1 dcredit=-1/' /etc/pam.d/system-auth
fi
#
echo "更改之后的结果为： `egrep -v "auth|account|session" /etc/pam.d/system-auth |grep "requisite" |sed '/^#/d' |sed '/^$/d'` "
#
#
#
echo "检查使用IP协议远程维护的设备是否配置SSH协议，禁用telnet协议"
#
cp -p /etc/services /etc/services.bak
sed -i 's/^\(telnet.*23\)/#\1/' /etc/services
echo "成功禁止 23 端口号" 
#
#
TENT=`egrep "#telnet" /etc/services |grep 23`
echo "更改之后的结果是： $TENT"
#
echo "检查是否启用cron行为日志功能" 
#
OPP=`cat /etc/syslog.conf |sed '/^#/d' |sed '/^$/d' |awk '($1~/^cron/) &&  ($2!~/-/) {print $1}'`
#
if [ -n "$OPP" ];then
	echo "已启用cron日志功能： `cat /etc/syslog.conf |sed '/^#/d' |sed '/^$/d' |awk '($1~/^cron/) &&  ($2!~/-/) {print $1"\t"$2}'`  "
else
	echo "没有启用cron 日志功能，请手动修改！"
fi
#
echo "检查是否配置远程日志功能"
#
if [ -f /etc/syslog.conf ];then
	SYSLOG=/etc/syslog.conf
	echo "存在 syslog.conf" 
else
	SYSLOG=/etc/rsyslog.conf
	echo "存在 rsyslog.conf"
fi
#
OCCA=`cat $SYSLOG |sed '/^#/d' |sed '/^$/d' |awk '($1~/*/) && ($2~/@/) {print $1$2}' |awk -F"@" '{print $2}'`
#
if [ -n "$OCCA" ];then
	echo "已经配置远程日志功能，配置内容：$OCCA"
else
	echo "请手动配置 $SYSLOG日志，追加 *.*@IP"
fi
#
echo "检查是否对系统账号进行登录限制"
#
PAS_O=`egrep -w  "lp|nobody|uucp|games|rpm|smmsp|nfsnobody" /etc/shadow |awk -F":" '($2 !~ /!/) {print $1}'`
#
#
for i in $PAS_O
do
usermod -L $i
done
#
echo "已锁定的帐号为：" `cat /etc/shadow |awk -F":" '($2 ~ /!/) {print $1":"$2}'` 
#
echo "检查telnet Banner 设置"
	test -f /etc/issue && echo " Authorized users only. All activity may be monitored and reported " \
> /etc/issue && echo  "issue is success: `cat /etc/issue`"
	test  -f /etc/issue.net && echo " Authorized users only. All activity may be monitored and reported " \
> /etc/issue.net && echo " issue.net is success: `cat /etc/issue`"
#After check ssh set Banner for login.
# 
echo "检查是否设置ssh成功登录后Banner"
#
#if motd true then echo something to file in motd,
#	else touch file of motd
#
test -f /etc/motd || touch /etc/motd && echo  "Login success. All activity will be monitored and reported " > /etc/motd && \
echo "成功设置ssh登录后警告:" `cat /etc/motd`
#
# set ssh login ago show warning Banner
echo "检查是否设置ssh登录前警告Banner"
#
if [ -f /etc/ssh_banner ];then
	chown bin:bin /etc/ssh_banner
	chmod 644 /etc/ssh_banner
	echo " Authorized only. All activity will be monitored and reported " > /etc/ssh_banner
else
        touch /etc/ssh_banner
        chown bin:bin /etc/ssh_banner
        chmod 644 /etc/ssh_banner
        echo " Authorized only. All activity will be monitored and reported " > /etc/ssh_banner
fi
#
echo "已设置ssh 登录前警告为： `cat /etc/ssh_banner`"
#
#
#
#
echo ".检查是否关闭数据包转发功能（适用于不做路由功能的系统）"
IPFD=`cat /proc/sys/net/ipv4/ip_forward`
if [ "$IPFD" == "0" ];then
        echo "数据包转发功能已关闭"
else
        echo "数据包转发功能未关闭，请修改！"
fi
#
#Use last -f check /var/log/wtmp,it's file only use command of "last -f" see.
# The result that output into screen,please look up in screen.  
echo ".检查是否对登录进行日志记录"
echo "`last -f /var/log/wtmp |grep -v 'root'`"
#
#
#
echo "检查账户认证失败次数限制"
#
OPQ=$(sed -n '/^\(auth.*pam_tally.so\)/=' /etc/pam.d/system-auth})
test -z "$OPQ" && \
echo "auth required pam_tally.so deny=5 unlock_time=600 no_lock_time" >> /etc/pam.d/system-auth && \
echo "更改后为：" `grep '^auth' /etc/pam.d/system-auth |grep 'deny=5'`
#
#
echo "检查安全事件日志配置"
test -f /var/adm/messages && \
echo "安全事件日志已配置" || \
echo "安全事件日志没有配置,配置方法：echo *.err;kern.debug;daemon.notice /var/adm/messages\
 到文件 /etc/syslog.conf,创建目录及文件，/etc/init.d/syslog restart "
#
#Whether set command of su,please check it usage.
#Output result into screen,look up result later.
echo "检查是否配置su命令使用情况记录"
if [ -f /etc/syslog.conf ];then
        CAMK=/etc/syslog.conf
else
        CAMK=/etc/rsyslog.conf
fi
OCCO=`cat $CAMK |egrep "authpriv" |sed '/^#/d' |sed '/^*/d' |awk '{print $2}'`
if [ -z "$OCCO" ];then
        echo "没有配置 su 命令使用记录，请手动修改！"
else
        echo "已配置su 命令使用记录，日志为： $OCCO"
fi
#
#
#Check shadow,passwd,group that three file of permission.
echo "检查是否配置用户所需最小权限"
echo "shadow|passwd|group,三个文件的权限为："
#
ls -l /etc/shadow 
ls -l /etc/passwd
ls -l /etc/group
#
#How much check password use. 
#5 is good.
echo "检查密码重复使用次数限制"
OOCC=`grep 'remember=5' /etc/pam.d/system-auth |awk '{print $1}'`
test -z "$OOCC" && sed -i '/^\(password.*sufficient.*\)/s/use_authtok/& remember=5/' /etc/pam.d/system-auth && \
echo "修改后密码重复使用次数为 ：" `grep password /etc/pam.d/system-auth |grep sufficient |awk '{print $9}'`
