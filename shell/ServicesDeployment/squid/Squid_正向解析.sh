



auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated

http_port 3128
#服务端口可自定义




## acl
acl localnet src 0.0.0.1-255.255.255.255
#允许所有

#acl例子
acl Foo src 172.16.44.21/255.255.255.255 
acl Foo src 172.16.44.21/32
acl Foo src 172.16.44.21
acl Xyz src 172.16.55.32/255.255.255.248   
acl Xyz src 172.16.55.32/28
acl Bar src 172.16.66.0/255.255.255.0
acl Bar src 172.16.66.0/24
acl Bar src 172.16.66.0
#ACL文档http://www.squid-cache.org/Versions/v3/3.5/cfgman/acl.html

#日志/var/log/squid/cache.log