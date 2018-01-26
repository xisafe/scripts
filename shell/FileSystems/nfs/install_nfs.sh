#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-25 15:05:12
#Description:	
# --------------------------------------------------


install_nfs()
{
	  rpcbind
	#先安装nfs文件系统，在通过rpc传输
	chkconfig nfs on
	chkconfig rpcbind on
}



set_nfs()
{
	mkdir /data/NFS
	echo "/data/NFS  10.0.0.0/8(ro,sync,no_root_squash)" >/etc/exports
	#设置nfs路径文件只读权限
	service rpcbind start
	service nfs start
}

mount_nfs()
{
mount -t nfs 192.168.100.1:/data/NFS  /data
#挂载
umount /data
#卸载本地挂载点	
}


test_nfs()
{
## 测试连接
rpcinfo 192.168.100.1
#检查rpc传输
showmount -e   192.168.100.1
#查看nfs服务的文件路径
}



readinfo()
{
## 补充
配置选项说明：
    ro          #read only    
    rw       	#read write
    no_root_squash  #信任客户端，对应 UID
    noaccess       	#客户端不能使用 
    sync	         #同步
    async	         #异步方式
    all_squash：    将远程访问的所有普通用户及所属组都映射为匿名用户或用户组（nfsnobody）；
  no_all_squash： 与all_squash取反（默认设置）；
  root_squash：   将root用户及所属组都映射为匿名用户或用户组（默认设置）；
  no_root_squash：与rootsquash取反；
}


install_nfs
set_nfs