#!/bin/bash

# --------------------------------------------------
#发布者:		以谁为师  
#Email:			admin@attacker.club
#网站:			blog.attacker.club
#Description:	Centos服务器初始化
# --------------------------------------------------

mkdir -p /pxe/iso >/dev/nell 2>&1
####---- 挂载镜像 ----####
mount /dev/cdrom /pxe/iso  >/dev/nell 2>&1
#镜像挂载
if [ ! -d  /pxe/iso/Packages ]; then
echo
echo -e "\033[41;36m   mount failed !  CD-ROM is not detected !\033[0m" 
echo
exit
fi


####---- 设置ip和网段变量 ----####
read -p "Please input IP address": IPADDR 
mask=$(echo $IPADDR| cut -d '.' -f 1-3)

####---- 本地yum库 ----####
mv /etc/yum.repos.d/*repo .

cat > /etc/yum.repos.d/local.repo<<EOF
[base]
baseurl=file:///pxe/iso
enable=1
gpgcheck=0
EOF
yum clean all



####---- yum安装所有服务 ----####
yum install dhcp tftp-server httpd syslinux net-tools -y
mv *repo /etc/yum.repos.d/  >/dev/nell 2>&1
rm /etc/yum.repos.d/local.repo -rf
#恢复原来的yum库配置
yum clean all

subnet=$(ifconfig |grep $IPADDR| awk '{print $4}')
router=$(route |grep default|awk '{print $2}')

####---- dhcp配置 ----####
cat >/etc/dhcp/dhcpd.conf<<EOF
subnet $mask.0  netmask $subnet {
range dynamic-bootp $mask.10 $mask.60;
option routers $router;
filename "pxelinux.0";
next-server $IPADDR;
}
EOF

####---- tftpd配置 ----####
sed -i 's#/var/lib/tftpboot#/pxe/tftpboot#g' /etc/xinetd.d/tftp
sed -i 's/disable.*$/disable = no/g' /etc/xinetd.d/tftp
mkdir /pxe/tftpboot >/dev/nell 2>&1
cp /usr/share/syslinux/pxelinux.0 /pxe/tftpboot/
cp  /pxe/iso/isolinux/vmlinuz /pxe/tftpboot/
cp  /pxe/iso/isolinux/initrd.img  /pxe/tftpboot/
cp  /pxe/iso/isolinux/boot* /pxe/tftpboot/
cp  /pxe/iso/isolinux/vesamenu.c32 /pxe/tftpboot/
mkdir /pxe/tftpboot/pxelinux.cfg >/dev/nell 2>&1

cat >/pxe/tftpboot/pxelinux.cfg/default<<EOF
default vesamenu.c32
timeout 6000
#timeout -1 停留界面
display boot.msg
menu background splash.jpg
label localhost
menu label  ^Local Boot
menu default
localboot 0x80

label linux
menu label ^Install Centos 7
kernel vmlinuz
append initrd=initrd.img ks=http://$IPADDR/ks.cfg
EOF
chmod  o+rwx /pxe/tftpboot/ -R

####---- http配置 ----####
sed -i 's#/var/www/html#/pxe#g' /etc/httpd/conf/httpd.conf

####---- ks.cfg自动脚本 ----####
cat >/pxe/ks.cfg<<EOF
text
url --url http://$IPADDR/iso
firstboot --enable
ignoredisk --only-use=sda
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
network  --bootproto=dhcp --device=eno16777736 --ipv6=auto --activate
network  --hostname=www.to-share.net
rootpw 123456
#root password
timezone Asia/Shanghai --isUtc
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm
clearpart --all --initlabel
reboot

#安装软件包
%packages
@core
net-tools
%end

#安装结束后执行脚本
%post --interpreter=/bin/bash
chmod  +x  /etc/rc.local
echo /root/echo_ip.sh >> /etc/rc.local
cat >/root/echo_ip.sh<<Local-IP
#!/bin/bash
network_dir=/etc/sysconfig/network-scripts/ifcfg-eno16777736
echo >/etc/issue
echo "Server IP: \$(ip add |grep global |head -1|awk  '{print \$2}'|cut -d / -f 1)" >>/etc/issue
echo >>/etc/issue
sed -i 's#none#static#g'   \$network_dir
echo "IPADDR=\$(ip add |grep global |head -1|awk  '{print \$2}'|cut -d / -f 1)"  >> \$network_dir
echo "NETMASK=$subnet"  >> \$network_dir
echo "GATEWAY=$router"  >> \$network_dir
echo "DNS1=223.5.5.5"  >> \$network_dir
echo "DNS2=114.114.114.114"  >> \$network_dir
echo >>/etc/issue
sed -i '14d' /etc/rc.local
sed -i '14d' /etc/rc.d/rc.local
#删除14行
reboot
Local-IP
chmod +x /root/echo_ip.sh
#/root/echo_ip.sh
%end
EOF
####---- 启动服务 ----####
service xinetd restart >/dev/nell 2>&1
service dhcpd restart >/dev/nell 2>&1
service httpd restart >/dev/nell 2>&1
service iptables stop >/dev/nell 2>&1
systemctl stop firewalld >/dev/nell 2>&1
setenforce 0 
echo
echo -e "\t\t\t\t\033[3;032m[OK]\033[0m\n"