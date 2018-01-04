@echo off

route add 10.100.1.0  mask 255.255.255.0 192.168.150.1
:: 添加静态路由
route -p add 10.100.1.0  mask 255.255.255.0 192.168.150.1
:: 添加静态路由 永久生效


route delete 10.100.1.0
:: 删除路由条目

netsh interface ip set address name="本地连接"  static  192.168.1.235 255.255.255.0 192.168.1.1
:: 修改网卡ip地址
