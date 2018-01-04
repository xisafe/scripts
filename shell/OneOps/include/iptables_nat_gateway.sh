#!/bin/bash
# --------------------------------------------------
#Author:		LGhost
#Email:			admin@attacker.club
#Site:		    blog.attacker.club

#Last Modified time: 2017-11-17 00:36:50
#Description:	
# --------------------------------------------------


if [ ! -f /etc/sysconfig/iptables  ];then
yum install  iptables-services -y
#安装iptables防火墙


echo 1 >/proc/sys/net/ipv4/ip_forward #临时命令启用转发

grep  ip_forward  /etc/sysctl.conf || echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
/sbin/sysctl -p  #写入配置
#cat /proc/sys/net/ipv4/ip_forward #查看方法:开启后值为 1




wan=$(route |grep default|awk '{print $8}')
#出接口
iptables -A POSTROUTING -t nat  -o $wan -j MASQUERADE
#进行地址伪装 也可以使用-j SNAT --to 60.164.2x.x（公网ip)
iptables -A FORWARD  -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200 
#设置MTU，防止包过大 （关键）