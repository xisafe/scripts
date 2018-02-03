#!/bin/bash

yum install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
#依赖环境

if [ ! -f Python*gz ];then
	https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz
fi

tar zxf Python*gz
cd Python*
./configure --prefix=/usr/local
make && make  altinstall


#python3.6程序的执行文件：/usr/local/bin/python3.6
#python3.6应用程序目录：/usr/local/lib/python3.6
#pip3的执行文件：/usr/local/bin/pip3.6
#pyenv3的执行文件：/usr/local/bin/pyenv-3.6

cd/usr/bin
mv  python python.backup
ln -s /usr/local/bin/python3.6 /usr/bin/python
ln -s /usr/local/bin/python3.6 /usr/bin/python3


ls 	/usr/bin/yum* |xargs sed -i 's/python/python2/'
sed -i 's/python/python2/' /usr/libexec/urlgrabber-ext-down
#替换成python旧版本