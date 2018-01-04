centos6
echo  >  /etc/udev/rules.d/70-persistent-cd.rules
sed  -i '/HWADDR/d;/UUID/d' /etc/sysconfig/network-scripts/ifcfg-*


centos7
#卸载NetworkManager重启上不了网；通过指定网卡mac地址解决
systemctl disable NetworkManager
yum remove NetworkManager -y
systemctl enable network
nic_file=`ls /etc/sysconfig/network-scripts/ifcfg-e*`
ifconfig -a | grep ether | awk '{ print $2 }' | sed 's/.*/HWADDR=&/' >> ${nic_file}
