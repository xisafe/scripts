#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:32
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



Install_ntp()
{
	color_message "info" "install ntp server"
	(which ntpd|xargs rpm -qf ||yum install ntp -y ) &>/dev/null
}

Set_ntp ()
{
	color_message "info" "set ntp"
	
cat > /etc/ntp.conf <<EOF
restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
#默认的client拒绝所有的操作


restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap 
restrict 172.16.0.0 mask 255.240.0.0 nomodify notrap 
restrict 10.0.0.0 mask 255.0.0.0 nomodify notrap
#允许内网段地址查询本服务器

restrict 127.0.0.1
restrict -6 ::1
#允许本机地址一切的操作

server ntp1.aliyun.com iburst
server ntp2.aliyun.com iburst
server ntp3.aliyun.com iburst
server ntp4.aliyun.com iburst
server ntp5.aliyun.com iburst
server ntp6.aliyun.com iburst
server ntp7.aliyun.com iburst
#上层NTP服务(阿里云)
EOF
}

Run_ntp()
{
	chkconfig  ntpd on
	service  ntpd restart
}

Install_ntp
Set_ntp
Run_ntp