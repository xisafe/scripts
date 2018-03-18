#!/bin/bash
# --------------------------------------------------
#Author:  LJ
#Email:   admin@attacker.club

#Last Modified: 2018-03-12 17:34:04
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
iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
#清空及初始化filter及nat表

iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATE -j ACCEPT
#iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
#开放指定端口
iptables -I INPUT  -p icmp -s 0/0 -d 0/0 -j ACCEPT  
#允许icmp (ping)
iptables -A INPUT -p tcp --dport 22  -j ACCEPT
#放行ssh

iptables -A INPUT -p tcp -s 10.0.0.0/8 -j ACCEPT  
iptables -A INPUT -p tcp -s  172.16.0.0/16 -j ACCEPT  
iptables -A INPUT -p tcp -s 192.168.0.0/16 -j ACCEPT  
#内网网段信任


iptables -A INPUT -p tcp -s 223.5.5.5 -j ACCEPT 
#外网地址信任


iptables-save
service  iptables save
color  "info" '---- 策略导入完成 ----'
