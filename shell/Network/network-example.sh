#!/bin/bash


## 永久路由修改配置文件


route add default gw 10.0.0.1 metric 99
#网卡网关metric优先级为100,添加优先路由出口10.0.0.1

route add   default gw 10.0.0.1
#添加默认路由 
route del  default gw 10.0.0.1
#删除默认路由 
route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.1.1 eth0
#还可以这样加默认路由

wan=$(route |grep default|awk '{print $8}')
#匹配出接口地址


gateway=`route  -n | awk '$2~/192/{print $2}'|uniq`
#匹配192段的网关ip


route add  default gw $gateway  metric 1
#添加默认路由metric 默认为0

route add -net 10.0.0.0/8 gw  10.0.0.1

route add -net 172.16.32.0/20 gw  192.168.32.1
route add -net 192.168.32.0/20 gw  192.168.32.1
route add -host 183.129.201.236  gw 10.25.20.212

#给一个网段添加静态路由
route del  -net 192.168.2.0  netmask 255.255.255.0 
#删除去192.168.2网段的路由
route del  -net 192.168.12.0  netmask 255.255.252.0  gw 192.168.8.1
#删除去192.168.12.0网段出口192.68.8.1的路由 
route del  -net 10.0.0.0  netmask 255.0.0.0  gw 10.0.0.1 metric 99





