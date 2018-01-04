#!/bin/bash
# --------------------------------------------------
#Author:		LGhost
#Email:			admin@attacker.club
#Site:		    blog.attacker.club

#Last Modified time: 2017-11-17 10:27:36
#Description:	
# --------------------------------------------------

fdisk /dev/sdb
#m列表p查看分区n新加d删除w保存退出
mkfs.ext3 /dev/sdb2
mkdir /data
mount /dev/sdb1 /data

 vi /etc/fstab
 /dev/sdb1   /data  ext4   defaults       12
 blkid  #可查硬盘uuid