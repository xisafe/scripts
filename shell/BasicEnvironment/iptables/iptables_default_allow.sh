#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-12-08 17:41:43
#Description:	
# --------------------------------------------------

function confirm()
{
  read -p 'Are you sure to Continue? [Y/N]:' answer
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
#确认运行脚本


function color()
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

color  "warn"  '---- 安装iptables ----'
if [ ! -f /etc/sysconfig/iptables  ];then
yum install  iptables-services -y
#安装iptables防火墙

chkconfig iptables on
systemctl enable  iptables
systemctl disable  firewalld
systemctl stop  firewalld
service iptables restart
#开机启动项、禁用firewalld
fi

color  "info" '---- 清空iptables策略 ----'
#清空及初始化filter及nat表
iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat


iptables -P INPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATE -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 22,80,443 -j ACCEPT
#开放端口



iptables-save
