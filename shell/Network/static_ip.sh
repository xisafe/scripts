#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:38
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


Centos_init()
{
  rhel_version=`grep -oP  '\d'   /etc/redhat-release|head -1`
  #系统版本
  if [ $rhel_version = 6 ] ;then
    echo  > /etc/udev/rules.d/70-persistent-net.rules &>/dev/null
  fi

  if [ $rhel_version = 7 ] ;then
    color_message "info" "单用卡配置" 
    echo > /etc/udev/rules.d/90-eno-fix.rules &>/dev/null
    interface=`ifconfig -a |grep mtu|grep -v lo|awk -F: '{print $1}'`
    ifcfg="/etc/sysconfig/network-scripts/ifcfg-eth"
    mv  /etc/sysconfig/network-scripts/ifcfg-$interface  ${ifcfg}0
    cp /etc/sysconfig/grub /etc/sysconfig/grub.bak 
    
    grub2-mkconfig -o /boot/grub2/grub.cfg

    systemctl  disable  NetworkManager
    systemctl  stop  NetworkManager
  fi
}


Set_ipaddr()
{
	
	IPADDR=`ifconfig eth0 2>/dev/null |grep inet|awk '{print $2}'`

if [ ! -z $IPADDR ]; then

	color_message "info" "set static IP"

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
MTU=1454
IPADDR=$IPADDR
$(route |grep default| awk '{print "GATEWAY="$2}')
$(ifconfig eth0 |grep inet|awk '{print "NETMASK="$4}')
$(ifconfig  eth0  | awk '/ether/ {print "HWADDR="$2}')
EOF
sed -i "s/dhcp/static/" /etc/sysconfig/network-scripts/ifcfg-eth0
reboot
else
	color_message "warn" "Not found eth0"
fi
}
Centos_init
Set_ipaddr