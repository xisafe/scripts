#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-12-15 14:56:51
#Description:	
# --------------------------------------------------


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

iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATE -j ACCEPT

iptables -A INPUT -p tcp -s 10.0.0.0/8  -j ACCEPT
#内网段
iptables -A INPUT -p tcp -s  8.8.8.8   -j ACCEPT
#外网ip


iptables-save