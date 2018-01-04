#!/bin/bash
#swap 减容 ，/home 扩容

lvdisplay  
#显示LV详细信息
free -m #看swap分区变化
swapoff -a
free -m #看swap分区变化
lvreduce -L -5000m  /dev/mapper/VolGroup-LV_SWAP  #将lv_swap分区大小减少5G
mkswap  /dev/mapper/VolGroup-LV_SWAP
swapon  /dev/mapper/VolGroup-LV_SWAP
free -m #看swap分区变化
vgdisplay  |grep -i free
#查看vg里面空闲容量
df -h 
#查看home扩容前的空间
lvextend -L +5000m /dev/VolGroup/LV_HOME   #将lv_swap分区大小增加XXXXM
resize2fs /dev/VolGroup/LV_HOME           #逻辑卷大小改变立即生效
df -h    #查看系统磁盘大小

#http://blog.attacker.club/运维/lvm2.html