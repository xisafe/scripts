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



install_ntp()
{
	color_message "info" "install ntp client"
	(which ntpd|xargs rpm -qf ||yum install ntp -y ) &>/dev/null
}

set_ntp ()
{
	color_message "info" "set ntp"
	ntpaddr="ntp2.aliyun.com"


cat > /etc/ntp.conf <<EOF
keys /etc/ntp/keys
logfile /var/log/ntp.log
driftfile /var/lib/ntp/drift

restrict default kod nomodify notrap nopeer noquery
restrict -6 default kod nomodify notrap nopeer noquery
#拒绝默认的client操作
restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap nopeer noquery
restrict 172.16.0.0 mask 255.240.0.0 nomodify notrap nopeer noquery
restrict 10.0.0.0 mask 255.0.0.0 nomodify notrap nopeer noquery
#拒绝指定网段client操作


restrict 127.0.0.1
restrict -6 ::1
#允许本机地址一切的操作

server   $ntpaddr iburst    
fudge    $ntpaddr stratum 10
#内网时间服务器
EOF
}


