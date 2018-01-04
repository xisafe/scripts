#!/bin/bash
# --------------------------------------------------
#Author:  LGhost
#Email:   admin@attacker.club
#Site:    blog.attacker.club

#Last Modified: 2018-01-03 23:45:57
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



mysqldir=/usr/local/mysql
#安装目录
datadir=/home/data/mysql
#数据目录
dbrootpwd=blog.attacker.club
#数据库root密码


/etc/init.d/mysqld stop
pkill mysqld
rm $mysqldir  /data/mysql/  /etc/my.cnf  /etc/init.d/mysqld -rf
#关闭已有mysql，并删除mysql文件

yum install -y  mysql-devel perl  autoconf automake imake libxml2-devel\
 expat-devel cmake gcc gcc-c++ libaio libaio-devel bzr bison libtool ncurses5-devel
#更新依赖包
 
if [ ! -f mysql*glibc*tar.gz  ];then
    wget -c http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.35-linux-glibc2.5-x86_64.tar.gz
fi
tar  zxvf mysql-5*gz -C /usr/local
mv /usr/local/mysql-5* $mysqldir

groupadd -g 501 mysql || groupadd  mysql
useradd  -u 501  -M -s /sbin/nologin -g mysql -d $mysqldir mysql || useradd   -M -s /sbin/nologin -g mysql -d $mysqldir mysql

useradd mysql -g mysql -M -s /sbin/nologin
mkdir -p $datadir
chown mysql:mysql -R $datadir
chown mysql:mysql -R $mysqldir

cp $mysqldir/support-files/mysql.server /etc/init.d/mysqld -rf
#sed -i "s#BASEDIR=#BASEDIR=$mysqldir#g" /etc/init.d/mysqld
#sed -i "s#datadir=#datadir=$datadir#g" /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
# my.cf
cat > /etc/my.cnf << EOF

[client]
port = 3306
socket = /tmp/mysql.sock

[mysqld]
port = 3306
socket = /tmp/mysql.sock

basedir = $mysqldir
pid-file = $datadir/mysql.pid
user = mysql
bind-address = 0.0.0.0
server-id = 1


# DATA STORAGE #
datadir = $datadir
long_query_time = 1

# BINARY LOGGING #
#binlog_format = row
#log-bin = $datadir/mysql-bin.log
#binlog日志文件
#expire-logs-days = 14
#binlog过期清理时间
#sync-binlog = 1
#max_binlog_size = 500M
#binlog每个日志文件大小
#binlog_cache_size       = 4m
#binlog缓存大小
#max_binlog_cache_size   = 512m                     
#最大binlog缓存大小
# REPLICATION #
#relay-log = $datadir/relay-bin.log
#slave-net-timeout = 60

# CACHES AND LIMITS #
tmp_table_size = 32M
max_heap_table_size = 32M
max_connections = 500
thread_cache_size = 50
open_files_limit = 65535
table_definition_cache = 4096
table_open_cache = 4096

# LOG
log_error = $datadir/error.log
slow-query-log-file = $datadir/slow.log
slow_query_log = 1
long_query_time = 1

# name-resolve
skip-name-resolve
skip-host-cache


#skip-networking
back_log = 300

max_connections = 1000
max_connect_errors = 6000
open_files_limit = 65535
table_open_cache = 128 
max_allowed_packet = 4M
binlog_cache_size = 1M
max_heap_table_size = 8M
tmp_table_size = 16M

read_buffer_size = 2M
read_rnd_buffer_size = 8M
sort_buffer_size = 8M
join_buffer_size = 8M
key_buffer_size = 4M

thread_cache_size = 8

query_cache_type = 1
query_cache_size = 8M
query_cache_limit = 2M

ft_min_word_len = 4

log_bin = mysql-bin
binlog_format = mixed
expire_logs_days = 30

performance_schema = 0

#lower_case_table_names = 1

skip-external-locking

default_storage_engine = InnoDB
#default-storage-engine = MyISAM
innodb_file_per_table = 1
innodb_open_files = 500
innodb_buffer_pool_size = 64M
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_thread_concurrency = 0
innodb_purge_threads = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120

bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 8M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1

interactive_timeout = 28800
wait_timeout = 28800
explicit_defaults_for_timestamp = true

[mysqldump]
quick
max_allowed_packet = 16M

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M
EOF

Memtatol=`free -m | grep 'Mem:' | awk '{print $2}'`
if [ $Memtatol -gt 1500 -a $Memtatol -le 2500 ];then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 16@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 16M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 16M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 16M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 128M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 32M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 256@' /etc/my.cnf
elif [ $Memtatol -gt 2500 -a $Memtatol -le 3500 ];then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 32@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 32M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 32M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 64M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 512M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 64M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 512@' /etc/my.cnf
elif [ $Memtatol -gt 3500 ];then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 64@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 64M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 64M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 256M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 1024M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 128M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 1024@' /etc/my.cnf
fi
$mysqldir/scripts/mysql_install_db --defaults-file=/etc/my.cnf  --basedir=$mysqldir
export PATH=$mysqldir/bin:$PATH
[ -z "`cat /etc/profile | grep $mysqldir`" ] && echo "export PATH=$mysqldir/bin:\$PATH" >> /etc/profile 
.  /etc/profile


/etc/init.d/mysqld restart
color_message  "info"  "启动mysql"

$mysqldir/bin/mysql -e "grant all privileges on *.* to root@'%' identified by \"$dbrootpwd\" with grant option;" 2>/dev/null
#$mysqldir/bin/mysql -e "grant all privileges on *.* to root@'localhost' identified by \"$dbrootpwd\" with grant option;" 2>/dev/null
#添加localhost和远程root账号密码

$mysqldir/bin/mysql -uroot -p$dbrootpwd -e "delete from mysql.user where Password='';" 2>/dev/null
$mysqldir/bin/mysql -uroot -p$dbrootpwd -e "delete from mysql.db where User='';" 2>/dev/null
$mysqldir/bin/mysql -uroot -p$dbrootpwd -e "delete from mysql.proxies_priv where Host!='localhost';" 2>/dev/null
$mysqldir/bin/mysql -uroot -p$dbrootpwd -e "drop database test;" 2>/dev/null
#删除空密码账号



 echo 
 echo   -e "\t\t\t\tMysql密码:\033[3;032m\"$dbrootpwd\"  \033[0m\n"
 echo 

ln -s $mysqldir/lib/libmysqlclient.so.18 /usr/lib64/libmysqlclient.so.18
#
、

qos lr outbound cir 30240 cbs 2048000