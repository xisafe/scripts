#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club
#Site:        blog.attacker.club

#Site:blog.attacker.club  Mail:admin@attacker.club
#Date:2017-07-01 21:30:54 Last:2017-08-22 11:49:22
#Description: 
# --------------------------------------------------

function message()
{
  case "$1" in
      "warn")
      echo -e "\e[1;31m$2\e[0m"
      ;;
      "notice")
      echo -e "\e[1;35m$2\e[0m"
      ;;
      "info")
      echo -e "\e[1;33m$2\e[0m"
      ;;
  esac
}



function confirm()
{
  read -p 'Are you sure to Continue?[Y/]:' answer
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


# Zabbix Server address
read -p "Please input ZabbixServer IP": IPADDR


#配置变量
zbx_pwd='r00tzbx'
website='/www/zabbix'
DBSocket=$(grep  socket  /etc/my.cnf| awk  '{print $3}'|uniq)



pkill zabbix
rm /usr/local/zabbix_proxy/ /etc/init.d/zabbix_* /etc/zabbix/  -rf
                                                                                                       -rf
message "notice" "清理zabbix残余文件"


grep zabbix /etc/passwd || groupadd zabbix ;useradd -M -s /sbin/nologin -g  zabbix zabbix
message "info" "添加用户"


#---- zabbix server settings ----
rm zabbix-3* -rf

if   [ ! -f zabbix-3.*.tar.gz  ];then
	wget -c https://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.6/zabbix-3.2.6.tar.gz
	yum install  -y c++ gcc telnet openldap openldap-devel  net-snmp-devel net-snmp-utils  curl-devel unixODBC-devel OpenIPMI-devel  autoconf libssh2-devel java-1.8.0-openjdk-devel java-1.8.0-openjdk
	updatedb
	mysql_config=(locate -r  mysql_config$)
	tar zxvf  zabbix-3*.tar.gz
cd  zabbix-3*

./configure --prefix=/usr/local/zabbix_proxy --sysconfdir=/etc/zabbix \
--enable-proxy --enable-agent \
--enable-ipv6 --enable-java  --with-net-snmp --with-libcurl \
--with-openipmi --with-unixodbc --with-ldap --with-ssh2 \
--with-mysql=$mysql_config

if [ $? -ne 0 ];then
 message "warn" "编译失败";exit 1
fi

make &&make install
message "info" "编译安装完毕 ！"

netstat -tnpl|grep mysql &> /dev/null
if [ $? -ne 0 ];then
 message "warn" "mysql is off";exit 1
fi
mysql  -e "show databases"
if [ $? -ne 0 ];then
 message "warn" "Mysql localhost password is not empty ！";exit 1
fi


mysql -e "drop database zabbix;"
message "notice"  "删除数据库"
mysql -e   "create database zabbix character set utf8;"
message "info" "创建zabbix数据库"
mysql -e   "grant all privileges on zabbix.* to zabbix@127.0.0.1 identified by '$zbx_pwd';"
mysql -e   "grant all privileges on zabbix.* to zabbix@localhost identified by '$zbx_pwd';"
message "info"  "创建zabbix数据库登录账号密码"

mysql  -f zabbix < database/mysql/schema.sql
message "info" "数据导入成功 ！"


#cp -rp frontends/php $website
#chown www:www  $website -R
#message "info"  "拷贝文件到站点；添加目录所属"

cp misc/init.d/fedora/core/zabbix_agentd /etc/init.d/ 
chmod 755 /etc/init.d/zabbix_*
#essage "info"  "拷贝执行程序到/etc/init.d"
sed -i "s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix_proxy#g" /etc/init.d/zabbix_agentd


cat >/etc/zabbix/zabbix_proxy.conf<<EOF
ProxyMode=0
LogFileSize=0
LogSlowQueries=3000
Timeout=4
Server=${IPADDR}
#zabbix服务端IP
Hostname=Zabbix_proxy
#必须和WEB页面添加代理时设置的名称一致
LogFile=/tmp/zabbix_proxy.log
#日志文件路径
DBHost=localhost
#数据库IP
DBName=zabbix
#数据库名
DBUser=zabbix
#数据库用户名
DBPassword=r00tzbx
#数据库密码
DBSocket=/tmp/mysql.sock
DBPort=3306
DataSenderFrequency=5
#数据同步间隔
ConfigFrequency=60
#配置文件同步间隔
ProxyLocalBuffer=0
#当数据发送到Server，还要在本地保留多少小时.不保留
ProxyOfflineBuffer=3
#当数据没有发送到Server，在本地保留多少小时，3小时。
HeartbeatFrequency=60
#心跳检测代理在Server的可用性
ConfigFrequency=300
#代理多久从Server获取一次配置变化，默认3600秒.
DataSenderFrequency=3
#代理收集到数据后，多久向Server发送一次..


ExternalScripts=/etc/zabbix/externalscripts
#外部脚本目录
FpingLocation=/usr/sbin/fping
EOF


fi

