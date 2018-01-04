gateway=`route  -n | awk '$2~/^192/{print $2}'|uniq`
old-way=`route  -n | awk '$3~/252.0$/{print $1}'|uniq`
#获取地址

route del -net 0.0.0.0 netmask 0.0.0.0 gw  $gateway
route del -net 0.0.0.0 netmask 0.0.0.0 gw  10.0.0.1
#route del -net 0.0.0.0 netmask 0.0.0.0 
route del -net $old-way netmask 255.255.252.0
#删除默认路由


route add  default gw $gateway  metric 1
#默认路由


route add -net 192.168.0.0/16 gw $gateway
route add -net 172.16.0.0/16 gw  $gateway
route add -net 10.0.0.0/8 gw  10.0.0.1
#静态路由
route add -host 10.4.233.10 gw $gateway
#zabbix
