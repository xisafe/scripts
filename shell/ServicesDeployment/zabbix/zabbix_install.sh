#!/bin/bash

#Author:Logos
#Mail: 	admin@attacker.club
#date: 	2017/4/19

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



#配置变量
zbx_pwd='r00tzbx'
website='/www/zabbix'
DBSocket=$(grep  socket  /etc/my.cnf| awk  '{print $3}'|uniq)
ip=`ip add|grep -w inet|egrep -v "127.0.0.1"|awk -F/ '{print $1}'|awk '{print $2}'`


pkill zabbix
rm /usr/local/zabbix/ /etc/init.d/zabbix_* /etc/zabbix/  /www/zabbix/  -rf
message "notice" "清理zabbix残余文件"


grep zabbix /etc/passwd || groupadd zabbix ;useradd -M -s /sbin/nologin -g  zabbix zabbix
message "info" "添加用户"


#---- zabbix server settings ----
#rm zabbix-* -f

if   [ ! -f zabbix-3.*.tar.gz  ];then
	wget -c https://nchc.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.2.6/zabbix-3.2.6.tar.gz || message "warn" 'Download failed';exit 1
else
	yum install  -y c++ gcc telnet openldap openldap-devel  net-snmp-devel net-snmp-utils  curl-devel unixODBC-devel OpenIPMI-devel  autoconf libssh2-devel java-1.8.0-openjdk-devel java-1.8.0-openjdk
	updatedb
	mysql_config=(locate -r  mysql_config$)
	tar zxvf  zabbix-3*.tar.gz
cd  zabbix-3*

./configure --prefix=/usr/local/zabbix --sysconfdir=/etc/zabbix \
--enable-server --enable-proxy --enable-agent \
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
mysql  -f zabbix < database/mysql/images.sql
mysql  -f zabbix < database/mysql/data.sql
message "info" "数据导入成功 ！"


cp -rp frontends/php $website
chown www:www  $website -R
message "info"  "拷贝文件到站点；添加目录所属"

cp misc/init.d/fedora/core/zabbix_* /etc/init.d/ 
chmod 755 /etc/init.d/zabbix_*
message "info"  "拷贝执行程序到/etc/init.d"



sed -i "s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g" /etc/init.d/zabbix_server
sed -i "s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix#g" /etc/init.d/zabbix_agentd

cat >/etc/zabbix/zabbix_server.conf<<EOF
LogFile=/tmp/zabbix_server.log
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=$zbx_pwd
DBSocket=$DBSocket
DBPort=3306

JavaGateway=127.0.0.1
JavaGatewayPort=10052
StartJavaPollers=5
StartDiscoverers=10

AlertScriptsPath=/etc/zabbix/alertscripts
ExternalScripts=/etc/zabbix/externalscripts
#外部脚本目录
#FpingLocation=/usr/sbin/fping

EOF



cat >/usr/local/nginx/conf/vhosts/zabbix.conf<<EOF
server {
    listen       800;
    server_name  _;
        index index.html  index.php;
        root $website;
        location ~ .*\.(php|php5)?$
        {
                fastcgi_pass  127.0.0.1:9000;
                fastcgi_index index.php;
                include fastcgi.conf;
        }
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
                expires 30d;
        }
        location ~ .*\.(js|css)?$
        {
                expires 1h;
        }
        access_log off;
}
EOF
echo '>>zabbix ok' > zabbix.txt 
echo 'web登录账号 admin；密码zabbix' >>  zabbix.txt
cat zabbix.txt 
echo "重新加载nginx配置，打开http://$ip:800"
fi
