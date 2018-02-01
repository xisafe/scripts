#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-30 22:13:06
#Description:	
# --------------------------------------------------


function color_message()
{ 
  case "$1" in
      "warn")
      echo -e "\e[1;31m$2\e[0m"
      ;;
      "info")
      echo -e "\e[1;33m$2\e[0m"
      ;;
  esac
}

function confirm()
{
  read -p 'Are you sure to Continue?[Y/n]:' answer
  case $answer in
  Y | y)
        echo -e "\n\t\t\e[44;37m Running the script \e[0m\n";;
  N | n)
        echo -e "\n\t\t\033[41;36mExit the script \e[0m\n"  && exit 0;;
  *)
        echo -e "\n\t\t\033[41;36mError choice \e[0m\n"  && exit 1;;
  esac
}



confirm


install_squid(){

cd  /usr/local/src
if [ ! -f squid*.tar.gz ];then
	 wget -c http://www.squid-cache.org/Versions/v3/3.5/squid-3.5.27.tar.gz 
fi
tar zxf  squid*.tar.gz
cd squid*
./configure \
--prefix=/usr \
--exec-prefix=/usr \
--includedir=/usr/include \
--datadir=/usr/share \
--libdir=/usr/lib64 \
--libexecdir=/usr/lib64/squid \
--localstatedir=/var \
--sysconfdir=/etc/squid \
--sharedstatedir=/var/lib \
--with-logdir=/var/log/squid \
--with-pidfile=/var/run/squid.pid \
--with-default-user=squid \
--enable-silent-rules \
--enable-dependency-tracking \
--with-openssl \
--enable-icmp \
--enable-delay-pools \
--enable-useragent-log \
--enable-esi \
--enable-follow-x-forwarded-for \
--enable-auth

make &make install

#--enable-ipf-transparent \

}


install_squid




#Generate Prviate Key
openssl genrsa -out attacker.club.private 2048  
#Greate Certificate siqning request
openssl req -new -key attacker.club.private -out attacker.club.csr  
 
 #sign certificate  
openssl x509 -req -days 3652 -in attacker.club.csr -signkey attacker.club.private -out attacker.club.cert


sed -i  '/http_port/d'  /etc/squid/
cat >> /etc/squid/
# Proxy Aware (non-intercepted traffic)
http_port 192.168.0.1:3128 ssl-bump cert=/etc/squid/example.com.cert key=/etc/squid/example.com.private generate-host-certificates=on version=1 options=NO_SSLv2,NO_SSLv3,SINGLE_DH_USE  
# Intercepted Traffic
https_port 192.168.0.1:3130 cert=/etc/squid/example.com.cert key=/etc/squid/example.com.private ssl-bump intercept generate-host-certificates=on version=1 options=NO_SSLv2,NO_SSLv3,SINGLE_DH_USE
 
# SSL Bump Config
ssl_bump stare all  
ssl_bump bump all  




# Recommended minimum configuration:
#
 
# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
 
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT
 
#
# Recommended minimum Access Permission configuration:
#
# Deny requests to certain unsafe ports
#http_access deny !Safe_ports
 
# Deny CONNECT to other than secure SSL ports
#http_access deny CONNECT !SSL_ports
 
# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager
 
#忽略证书错误
sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER
 
#使用TLSv1.0连接
sslproxy_version 4
sslproxy_options ALL
 
# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost
 
#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#
 
# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost
 
# And finally deny all other access to this proxy
http_access allow all
 
# Squid normally listens to port 3128
http_port 127.0.0.1:8888 ssl-bump cert=/etc/squid/my.cert key=/etc/squid/my.private generate-host-certificates=on
 
 
ssl_bump stare all  
ssl_bump bump all 
 
# Uncomment and adjust the following to add a disk cache directory.
#cache_dir ufs /var/cache/squid 100 16 256
 
# Leave coredumps in the first cache dir
coredump_dir /var/cache/squid
 
#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320





#http://zoufeng.net/2017/09/23/squid-proxy-with-ssl-bump/
