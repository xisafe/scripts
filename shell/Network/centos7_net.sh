#!/bin/bash
# --------------------------------------------------
#Author:  LJ
#Email:   admin@attacker.club

#Last Modified: 2018-03-18 22:43:53
#Description: 
# --------------------------------------------------


ifcfg="/etc/sysconfig/network-scripts/ifcfg-"
interface=`ifconfig -a |grep mtu|grep -v lo|awk -F: '{print $1}'`
HWADDR=`ifconfig  -a  | awk '/ether/ {print "HWADDR="$2}'`
grep $HWADDR ${ifcfg}eth0
if [ $? = 1 ];then
	sed -i '/HWADDR/d' ${ifcfg}eth0
	sed -i  "\$a $HWADDR"  ${ifcfg}eth0
	rm -f ${ifcfg}$(interface) && reboot
fi