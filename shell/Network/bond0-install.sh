#!/bin/bash
# purpose to bind network 
# createby zgt 20150924
# editby zgt 20170601


for each in `ifconfig|grep -vE "lo|bond"|grep -oP "^[a-z]*[0-9]"`
do
cp /etc/sysconfig/network-scripts/ifcfg-${each} /etc/sysconfig/network-scripts/ifcfg-${each}.bak 
done

FILE_ETH0="/etc/sysconfig/network-scripts/ifcfg-eth0"

eval $(grep -Eo 'IPADDR=\S+' $FILE_ETH0)
eval $(grep -Eo 'NETMASK=\S+' $FILE_ETH0) 
eval $(grep -Eo 'GATEWAY=\S+' $FILE_ETH0) 

if [ -z "${IPADDR}" ]; then
	is_set="n"
	echo "ip current set: ${IPADDR}"
	# read -p "manual ipaddr set (y/n/pass):[n]" is_set
	# case "$is_set" in
	# 	y|Y|yes|Yes)
	# 	:
	# 	;;
	# 	n|no|NO|N)
	# 	exit 0
	# 	;;
	# 	pass)
	# 	;;
	# esac
fi

#如果eth0里面没有，就手工设置IP地址
IPADDR=${IPADDR:-10.0.10.2}
NETMASK=${NETMASK:-255.0.0.0}
GATEWAY=${GATEWAY:-10.0.0.1}


is_mod=$(lsmod |grep bonding)
[ -z "$is_mod" ] && ( modprobe bonding >/dev/null ) || ( echo "bond mod not found" )

ls /etc/sysconfig/network-scripts/ifcfg-e*[0-2]|while read each
do
cat > $each << EOF
DEVICE=`echo $each|awk -F\- '{print $NF}'`
BOOTPROTO=none
MASTER=bond0
SLAVE=yes
ONBOOT=yes
USERCTL=no
EOF
test $? -eq 0 && echo "ifcfg-$(echo $each|awk -F\- '{print $NF}')"

done


cat > /etc/sysconfig/network-scripts/ifcfg-bond0 << EOF
DEVICE=bond0
BOOTPROTO=none
IPADDR="$IPADDR"
NETMASK="$NETMASK"
ONBOOT=yes
GATEWAY="$GATEWAY"
USERCTL=no
EOF
test $? -eq 0 && echo "ifcfg-bond0 "

cat >> /etc/modprobe.d/dist.conf << EOF
alias bond0 bonding
# 1 == failover 0 == lb
options bond0 miimon=100 mode=0
EOF
test $? -eq 0 && echo "dist.conf "

#cat >> /etc/resolv.conf << EOF
#nameserver 202.101.172.46
#nameserver 202.101.172.35
#test $? -eq 0 && echo "resolv.conf "

service network restart
test $? -eq 0 && echo ""

chkconfig NetworkManager off
service NetworkManager stop
chkconfig network on

