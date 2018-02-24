#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club


#Last Modified: 2018-02-24 18:04:37
#Description:   
# --------------------------------------------------

nginxdir=/usr/local/nginx

#站点路径
website=/www


CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)

if [ ! -d $nginxdir  ];then

  yum -y  install wget gcc gcc-c++  make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*

#建立站点目录
mkdir $website

#添加www组  
groupadd -g 500 www || groupadd www
#添加www用户  
useradd  -u 500  -M -s /sbin/nologin -g www  -d $website www || useradd   -M -s /sbin/nologin -g www  -d $website www

#安装nginx
rm -rf nginx-*

        if [ ! -f nginx-*.gz ];then
 wget  http://nginx.org/download/nginx-1.12.0.tar.gz
        fi

tar zxvf nginx-*.tar.gz

#伪装版本号
sed -i 's#nginx/#Microsoft-IIS7.0/#g'nginx-*/src/core/nginx.h
sed -i 's#"NGINX"#"Microsoft-IIS7.0"#g'nginx-*/src/core/nginx.h
sed -i 's#Server: nginx#Server: Microsoft-IIS7.0#g'nginx-*/src/http/ngx_http_header_filter_module.c
cd nginx-*

./configure --user=www \
--group=www \
--prefix=$nginxdir \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_mp4_module \
--with-http_flv_module \
--with-stream 
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install

#站点目录
chmod 770 $website
chown -R www:www $website
fi





if [  -d "$nginxdir" ];then

cat >$nginxdir/conf/nginx.conf<<EOF
user  www www;
worker_processes  2;
error_log  $nginxdir/logs/error.log crit;
pid        $nginxdir/logs/nginx.pid;
worker_rlimit_nofile 65535;
events
{
  use epoll;
  worker_connections 65535;
}
http {
        include       mime.types;
	
	server_tokens off;
        default_type  appliechoion/octet-stream;
        #charset  gb2312;
        server_names_hash_bucket_size 128;
        client_header_buffer_size 32k;
        large_client_header_buffers 4 32k;
        client_max_body_size 8m;
        sendfile on;
        tcp_nopush     on;
        keepalive_timeout 60;
        tcp_nodelay on;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        fastcgi_buffer_size 64k;
        fastcgi_buffers 4 64k;
        fastcgi_busy_buffers_size 128k;
        fastcgi_temp_file_write_size 128k;
        gzip on;
        gzip_min_length  1k;
        gzip_buffers     4 16k;
		gzip_http_version 1.0;
        gzip_comp_level 2;
        gzip_types       text/plain appliechoion/x-javascript text/css appliechoion/xml;
        gzip_vary on;
       # limit_zone  crawler  \$binary_remote_addr  10m;
       	 log_format '\$remote_addr - $remote_user [\$time_local] "\$request" '
                      '\$status $body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
        include $nginxdir/conf/vhosts/*.conf;
}
EOF

sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' $nginxdir/conf/nginx.conf

mkdir -p $nginxdir/logs/access
mkdir -p $nginxdir/conf/vhosts


cat >$nginxdir/conf/fastcgi.conf<<EOF
if (\$request_filename ~* (.*)\.php) {
    set \$php_url \$1;
}
if (!-e \$php_url.php) {
    return 403;
}
fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
fastcgi_param  QUERY_STRING       \$query_string;
fastcgi_param  REQUEST_METHOD     \$request_method;
fastcgi_param  CONTENT_TYPE       \$content_type;
fastcgi_param  CONTENT_LENGTH     \$content_length;
fastcgi_param  SCRIPT_NAME        \$fastcgi_script_name;
fastcgi_param  REQUEST_URI        \$request_uri;
fastcgi_param  DOCUMENT_URI       \$document_uri;
fastcgi_param  DOCUMENT_ROOT      \$document_root;
fastcgi_param  SERVER_PROTOCOL    \$server_protocol;
fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/\$nginx_version;
fastcgi_param  REMOTE_ADDR        \$remote_addr;
fastcgi_param  REMOTE_PORT        \$remote_port;
fastcgi_param  SERVER_ADDR        \$server_addr;
fastcgi_param  SERVER_PORT        \$server_port;
fastcgi_param  SERVER_NAME        \$server_name;
fastcgi_param  REDIRECT_STATUS    200;
EOF


cat >$nginxdir/conf/vhosts/default.conf<<EOF
server {
    listen       80 default;
    server_name  _;
        index index.html index.htm index.php;
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
        access_log  $nginxdir/logs/access/default.log;
}
EOF
cat >/etc/init.d/nginx<<LOGOS
#!/bin/bash

nginxd=$nginxdir/sbin/nginx
nginx_config=$nginxdir/conf/nginx.conf
nginx_pid=$nginxdir/logs/nginx.pid
RETVAL=0
prog="nginx"
[ -x \$nginxd ] || exit 0
start() {

    if [ -e $nginx_pid ] && netstat -tunpl | grep nginx &> /dev/null;then
        echo "nginx already running...."
        exit 1
    fi

    echo -n $"Starting \$prog!"
    \$nginxd -c \${nginx_config}
    RETVAL=\$?
    echo
    [ \$RETVAL = 0 ] && touch /var/lock/nginx
    return \$RETVAL
}
stop() {
    echo -n $"Stopping $prog!"
    \$nginxd -s stop
    RETVAL=\$?
    echo
    [ \$RETVAL = 0 ] && rm -f /var/lock/nginx
}
reload() {
    echo -n $"Reloading \$prog!"
    #kill -HUP `echo ${nginx_pid}`
 \$nginxd -s reload
    RETVAL=\$?
    echo
}
case "\$1" in
start)
        start
        ;;
stop)
        stop
        ;;
reload)
        reload
        ;;
restart)
        stop
        start
        ;;
*)
        echo $"Usage: \$prog {start|stop|restart|reload|help}"
        exit 1
esac
exit \$RETVAL

LOGOS
fi

ln -s $nginxdir/sbin/nginx /usr/local/sbin
chmod 755 $nginxdir/sbin/nginx
chmod +x /etc/init.d/nginx
/etc/init.d/nginx restart

