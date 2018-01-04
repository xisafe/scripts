#!/bin/bash
# --------------------------------------------------
#Author:    LGhost
#Email:     admin@attacker.club
#Site:      blog.attacker.club

#Last Modified: 2018-01-03 00:37:57
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



Install_LuaJIT()
{
    cd /usr/local/src
    if [ ! -f LuaJIT*tar.gz ];then
        wget http://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz
    fi
    tar zxvf   LuaJIT-*tar.gz
    cd LuaJIT-*
    make PREFIX=/usr/local/luajit
    make install PREFIX=/usr/local/luajit
    grep luajit   /etc/ld.so.conf || echo "/usr/local/luajit/lib"  >> /etc/ld.so.conf
    ldconfig 
}

Install_NDK()
{
    cd /usr/local/src
    if [ ! -f ngx_devel_kit*tar.gz ];then
        wget -O ngx_devel_kit-0.3.0.tar.gz https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz
    fi
    tar zxvf ngx_devel_kit*tar.gz
}

Install_lua-nginx-module()
{
    cd /usr/local/src
    if [ ! -f lua-nginx-module*tar.gz ];then
        wget -O lua-nginx-module.tar.gz https://codeload.github.com/openresty/lua-nginx-module/tar.gz/v0.10.11
    fi
    tar zxvf  lua-nginx-module*tar.gz 
}

Install_Nginx ()
{
    website=/www
    nginxdir=/usr/local/nginx
    CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
    if [ ! -d $nginxdir  ];then

        yum -y  install wget gcc gcc-c++  make libtool autoconf patch unzip \
        automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel \
        libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel \
        openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses \
        ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
        #安装基础环境

        mkdir $website #建立
        groupadd -g 500 www || groupadd www #添加www组  
        useradd  -u 500  -M -s /sbin/nologin -g www  -d $website www || useradd  \
        -M -s /sbin/nologin -g www  -d $website www #添加www用户 
        chmod 770 $website && chown -R www:www $website
    fi

    cd /usr/local/src
    if [ ! -f nginx-*.gz ];then
        wget  http://nginx.org/download/nginx-1.12.0.tar.gz
    fi
    tar zxvf nginx-*.tar.gz

    #伪装版本号
    sed -i 's#nginx/#Microsoft-IIS7.0/#g'nginx-*/src/core/nginx.h
    sed -i 's#"NGINX"#"Microsoft-IIS7.0"#g'nginx-*/src/core/nginx.h
    sed -i 's#Server: nginx#Server: Microsoft-IIS7.0#g'nginx-*/src/http/ngx_http_header_filter_module.c
    
    cd nginx-*
    ./configure --user=www --group=www \
    --prefix=$nginxdir \
    --without-http-cache \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-stream --with-pcre \
    --with-pcre-jit --with-ld-opt='-ljemalloc' \
    --with-ld-opt="-Wl,-rpath,/usr/local/luajit/lib" \
    --with-http_mp4_module --with-http_flv_module \
    --add-module=/usr/local/src/ngx_devel_kit-0.3.0  \
    --add-module=/usr/local/src/lua-nginx-module-0.10.11

    if [ $CPU_NUM -gt 1 ];then
        make -j$CPU_NUM
    else
        make
    fi
    make install

    

}


Install_LuaJIT
Install_NDK
Install_lua-nginx-module

export LUAJIT_LIB=/usr/local/luajit/lib
export LUAJIT_INC=/usr/local/luajit/include/luajit-2.1
Install_Nginx