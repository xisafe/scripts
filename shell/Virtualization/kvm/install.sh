#!/bin/bash
# --------------------------------------------------
#Author:		LJ
#Email:			admin@attacker.club
#Site:		    blog.attacker.club

#Site:blog.attacker.club  Mail:admin@attacker.club
#Date:2017-07-05 22:59:43 Last:2017-07-13 00:01:39
#Description:	安装iptables-services
# --------------------------------------------------



egrep "(vmx|svm)" --color=always /proc/cpuinfo ||echo " kvm not support" ; exit 1
#检查是否支持kvm
yum install  kvm  libvirt virt-manager virt-viewer python-virtinst bridge-utils -y
#安装依赖

systemctl  start libvirtd
systemctl  enable libvirtd
#启动kvm服务

lsmod | grep  -w --color kvm || echo "kvm not modules" ; exit 1
#检查kvm安装


yum install qemu-kvm
ln -s /usr/libexec/qemu-kvm /usr/bin/kvm
ln -s /usr/bin/qemu-img /usr/bin/kvm-img
#快捷命令


virsh -c qemu:///system list 
 #查看系统列表

virsh --connect qemu:///system
#进入virtual shell
list --all
#显示所有客户机

## CENTOS7  (virt-install)
virt-install
--name CENTOS7 \ #虚拟机名
--arch=x86_64 \	#模拟的CPU 构架
--vcpus=4 \              #配置虚拟机的vcpu 数目
--ram=8192  \ #指定内存MB
--check-cpu \  #检查确定vcpu是否超过物理 CPU数目，如果超过则发出警告。
--os-type=linix \ #要安装的操作系统类型，例如：'linux'、'unix'、'windows'
--os-variant=rhel7 \     #操作系统版本，如：'fedora6', 'rhel5', 'solaris10', 'win2k'
--disk path=/virhost/node7.img,device=disk,bus=virtio,size=20,sparse=true \   #虚拟机所用磁盘或镜像文件，size大小G
--bridge=br0 \           #指定网络，采用透明网桥
--noautoconsole \        #不自动开启控制台





# Windows 7 (qemu)
qemu-img create -f raw win7.img 10G
通过/usr/libexec/qume-kvm创建一个虚拟机，内存8024，从windows7.iso安装
qume-kvm -m 8024 -cdrom windows7.iso -drive 
file=win7.img,if=virtio,boot=on -fda  virtio-win-1.1.16.vfd -boot d -nographic -vnc :3



virsh net-list
#显示网络

chkconfig NetworkManager off
chkconfig network on
service NetworkManager stop
yum erase NetworkManager
#卸载NetworkManager


cd /etc/sysconfig/network-scripts/
cp ifcfg-eth0 
sed -i 's/DEVICE="eth0"/DEVICE="br0"/' ifcfg-br0
sed -i 's/TYPE=Ethernet/TYPE=Bridge/' ifcfg-br0
echo "BRIDGE=br0" >>ifcfg-eth0
#并且注释eth0 网卡ip地址和掩码

service network restart
#重启网卡
brctl show
#查看网络

mkdir  -p  /home/data/{iso,sys}

qemu-img create  -f raw  /home/data/sys/win7.img 40G

virt-install --name Win2012server --ram 8192 \
--vcpus=4 --disk path=/home/data/sys/win7.img,size=40  \
--network bridge=br0 --os-variant=windows --cdrom=/home/data/iso/cn_windows_server_2012_r2_vl_with_update_x64_dvd_4051059.iso  \
--vnclisten=0.0.0.0 --vncport=6904 --vnc


virsh --connect qemu:///system
list
#列出虚拟机
reboot
#重启虚拟机
#进入交互
shutdown 2
#关闭id 2的虚拟机
destroy 2
#删除id 2的虚拟机


qemu-img create -f raw /home/data/sys/win2012-1.img 30G

virt-install \
--accelerate \
--name windows2012 \
--ram 2048 \
--vcpus=2 \
--controller type=scsi,model=virtio-scsi \
--disk path=/home/data/sys/win2012-1.img.qcow2,size=50,sparse=true,cache=none,bus=virtio \
--cdrom=/home/data/iso/cn_windows_server_2012_r2_vl_with_update_x64_dvd_4051059.iso \
--graphics vnc,listen=0.0.0.0,port=5900,password=123456 \
--network bridge=br0 \
--os-type=windows \
--os-variant=win2012

iptables -A INPUT -s xxx.xxx.xxx.xxx -p tcp --dport 1521 -j ACCEPT 


https://imcat.in/kvm-virt-install-to-install-various-system-configurations/

qemu-img create -f raw win-1.img 40G

kvm -m 5000 -cdrom /home/data/iso/server2012.iso \
 -drive file=/home/data/sys/win-1.img,if=virtio,boot=on  -fda  virtio-win-1.1.16.vfd -boot d -nographic -vnc :3