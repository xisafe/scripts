#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:36
#Description:	
# --------------------------------------------------


function color_message()
{ 
  case "$1" in
      "warn")
      echo -e "\e[1;31m$2\e[0m"
      ;;
      "info")
      echo -e "\e[1;33m$2\e[0m"
      ;;
  esac
}

function confirm()
{
  read -p 'Are you sure to Continue?[Y/n]:' answer
  case $answer in
  Y | y)
        echo -e "\n\t\t\e[44;37m Running the script \e[0m\n";;
  N | n)
        echo -e "\n\t\t\033[41;36mExit the script \e[0m\n"  && exit 0;;
  *)
        echo -e "\n\t\t\033[41;36mError choice \e[0m\n"  && exit 1;;
  esac
}



confirm





Install_fail2ban()
{
	yum -y install fail2ban
	sed -i '/^#/d;/^$/d' /etc/fail2ban/fail2ban.conf

	grep DEFAULT  /etc/fail2ban/fail2ban.conf || cat >>  /etc/fail2ban/fail2ban.conf <<EOF
[DEFAULT]                                 #全局设置 
ignoreip = 127.0.0.1                      #忽略的IP列表,不受设置限制（白名单） 
bantime  = 600                            #屏蔽时间，单位：秒 
findtime  = 600                           #这个时间段内超过规定次数会被ban掉 
maxretry = 3                              #最大尝试次数 
backend = auto                            #日志修改检测机制（gamin、polling和auto这三种） 
 
[ssh-iptables]                            #针对各服务的检查配置，如设置bantime、findtime、maxretry和全局冲突，服务优先级大于全局设置 
enabled  = true                           #是否激活此项（true/false） 
filter   = sshd                           #过滤规则filter的名字，对应filter.d目录下的sshd.conf 
action   = iptables[name=SSH, port=ssh, protocol=tcp]                         #动作的相关参数 
sendmail-whois[name=SSH, dest=root, sender=fail2ban@example.com]   #触发报警的收件人 
logpath  = /var/log/secure                #检测的系统的登陆日志文件 
maxretry = 5                              #最大尝试次数 
EOF
    
   chkconfig fail2ban on  && service fail2ban start
}



Install_fail2ban

