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





Change_net()
{
	color_message "info" "单用卡配置"
	cp /etc/sysconfig/grub /etc/sysconfig/grub.bak 
	grub2-mkconfig -o /boot/grub2/grub.cfg
	#  net.ifnames=0 biosdevname=0
	systemctl  disable  NetworkManager
	systemctl  stop  NetworkManager
	echo > /etc/udev/rules.d/90-eno-fix.rules &>/dev/null
	interface=`ifconfig -a |grep mtu|grep -v lo|awk -F: '{print $1}'`
	ifcfg="/etc/sysconfig/network-scripts/ifcfg-eth"

	mv  /etc/sysconfig/network-scripts/ifcfg-$interface  ${ifcfg}0

cat > ${ifcfg}0 <<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
MTU=1454
EOF

chmod +x /etc/rc.local
cat >> /etc/rc.local <<EOF
grep HWADDR /etc/sysconfig/network-scripts/ifcfg-eth0|| echo HWADDR >>  /etc/sysconfig/network-scripts/ifcfg-eth0
HWADDR=`ifconfig  -a  | awk '/ether/ {print "HWADDR="$2}'`
sed -i  "/HWADDR/c $HWADDR"  /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart
EOF

}









