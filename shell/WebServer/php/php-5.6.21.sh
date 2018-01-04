#!/bin/bash
# --------------------------------------------------
#Author:    LGhost
#Email:     admin@attacker.club
#Site:      blog.attacker.club

#Last Modified: 2017-12-28 14:19:08
#Description:   
# --------------------------------------------------

phpdir=/usr/local/php
phpversion=php-5.6.21
if [ ! -d /usr/local/libpng.1.2.50 ];then
###############################安装php环境###############################
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ ! -f libiconv-1.13.1.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/libiconv-1.13.1.tar.gz
fi
rm -rf libiconv-1.13.1
tar zxvf libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f zlib-1.2.3.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/zlib-1.2.3.tar.gz
fi
rm -rf zlib-1.2.3
tar zxvf zlib-1.2.3.tar.gz
cd zlib-1.2.3
./configure
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

if [ ! -f freetype-2.1.10.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/freetype-2.1.10.tar.gz
fi
rm -rf freetype-2.1.10
tar zxvf freetype-2.1.10.tar.gz
cd freetype-2.1.10
./configure --prefix=/usr/local/freetype.2.1.10
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f libpng-1.2.50.tar.gz ];then
	#wget http://soft.phpwind.me/web/libpng-1.2.8.tar.gz
    wget http://oss.aliyuncs.com/aliyunecs/onekey/libpng-1.2.50.tar.gz
fi
rm -rf libpng-1.2.50
tar zxvf libpng-1.2.50.tar.gz
cd libpng-1.2.50
./configure --prefix=/usr/local/libpng.1.2.50
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

if [ ! -f libevent-1.4.14b.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/libevent-1.4.14b.tar.gz
fi
rm -rf libevent-1.4.14b
tar zxvf libevent-1.4.14b.tar.gz
cd libevent-1.4.14b
./configure
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f libmcrypt-2.5.8.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/libmcrypt-2.5.8.tar.gz
fi
rm -rf libmcrypt-2.5.8
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure --disable-posix-threads
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../..

if [ ! -f pcre-8.12.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/pcre-8.12.tar.gz
fi
rm -rf pcre-8.12
tar zxvf pcre-8.12.tar.gz
cd pcre-8.12
./configure
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

if [ ! -f jpegsrc.v6b.tar.gz ];then
	wget http://oss.aliyuncs.com/aliyunecs/onekey/jpegsrc.v6b.tar.gz
fi
rm -rf jpeg-6b
tar zxvf jpegsrc.v6b.tar.gz
cd jpeg-6b
if [ -e /usr/share/libtool/config.guess ];then
cp -f /usr/share/libtool/config.guess .
elif [ -e /usr/share/libtool/config/config.guess ];then
cp -f /usr/share/libtool/config/config.guess .
fi
if [ -e /usr/share/libtool/config.sub ];then
cp -f /usr/share/libtool/config.sub .
elif [ -e /usr/share/libtool/config/config.sub ];then
cp -f /usr/share/libtool/config/config.sub .
fi
./configure --prefix=/usr/local/jpeg.6 --enable-shared --enable-static
mkdir -p /usr/local/jpeg.6/include
mkdir /usr/local/jpeg.6/lib
mkdir /usr/local/jpeg.6/bin
mkdir -p /usr/local/jpeg.6/man/man1
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install-lib
make install
cd ..

#load /usr/local/lib .so
touch /etc/ld.so.conf.d/usrlib.conf
echo "/usr/local/lib" > /etc/ld.so.conf.d/usrlib.conf
/sbin/ldconfig


fi
###############################开始安装php###############################


rm -rf $phpversion
if [ ! -f $phpversion.tar.gz ];then
  wget  http://php.net/distributions/$phpversion.tar.gz
fi
tar zxvf $phpversion.tar.gz
cd $phpversion
./configure --prefix=$phpdir \
--enable-opcache \
--with-config-file-path=$phpdir/etc \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-fpm \
--enable-static \
--enable-inline-optimization \
--enable-sockets \
--enable-wddx \
--enable-zip \
--enable-calendar \
--enable-bcmath \
--enable-soap \
--with-zlib \
--with-iconv=/usr/local \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.6 \
--with-png-dir=/usr/local/libpng.1.2.50 \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--with-gettext \
--disable-maintainer-zts \
--disable-fileinfo

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./$phpversion/php.ini-production $phpdir/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "'$phpdir'/lib/php/extensions/no-debug-non-zts-20131226/"#'  $phpdir/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' $phpdir/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' $phpdir/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' $phpdir/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' $phpdir/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' $phpdir/etc/php.ini
#adjust php-fpm
cp $phpdir/etc/php-fpm.conf.default $phpdir/etc/php-fpm.conf
sed -i 's,user = nobody,user=www,g'   $phpdir/etc/php-fpm.conf
sed -i 's,group = nobody,group=www,g'   $phpdir/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   $phpdir/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   $phpdir/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   $phpdir/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   $phpdir/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   $phpdir/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = log/php-fpm.log,g'   $phpdir/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = log/\$pool.log.slow,g'   $phpdir/etc/php-fpm.conf
#self start
install -v -m755 ./$phpversion/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5
