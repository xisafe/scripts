

## 1.使用yum在线安装
yum install vsftpd -y


## 2.允许用户登陆
使user_list​为NO，只允许列表内用户访问
sed -i 's/userlist_enable=YES/userlist_deny=NO/g' /etc/vsftpd/vsftpd.conf

echo user1  >> /etc/vsftpd/user_list
echo user2  >> /etc/vsftpd/user_list
echo user3  >> /etc/vsftpd/user_list
#添加允许的登录ftp的系统账号
 
## 3.安全设置
黑名单 （user_list优先匹配，ftpusers 后匹配）
cat /etc/vsftpd/ftpusers 
root
bin
daemon
adm
......
限制匿名账号
sed -i  s/anonymous_enable=YES/anonymous_enable=NO/ /etc/vsftpd/vsftpd.conf
echo ftp >>  /etc/vsftpd/ftpusers
 #禁用匿名用户登录，不再跳出pub目录


### 方法1.将登录后的用户限制在自己的家目录
vi /etc/vsftpd/vsftpd.conf 
 chroot_local_user=YES

### 方法2.登录用户默认限制在家目录，但是chroot_list内的用户不受限制
vi /etc/vsftpd/vsftpd.conf 
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list

echo administrator  >> /etc/vsftpd.chroot_list



## 4.ftp主目录取消写入权限
chmod -w /ftp站点目录
5.启动服务 如centos7
systemctl restart vsftpd
systemctl enable vsftpd  #加入开机启动

 
我用www用户作为web服务的运行身份 ,ftp站点也是www家目录。
useradd  -u 500  -M -s /sbin/nologin -g www  -d /var/www   www
passwd www
#设置www用户登录密码


groupadd pubftp
useradd    -M -s /sbin/nologin -g pubftp -d /home/ftpsite/public pubftp
chown pubftp:pubftp /home/ftpsite/public
passftp
chmod a-w 
echo pubftp >> /etc/vsftpd.chroot_list
userlist_deny=NO


连接报错：
vsftpd: refusing to run with writable root inside chroot() 错误的解决办法
避免一个安全漏洞，从 vsftpd 2.3.5 开始，chroot 目录必须不可写
 chmod a-w /var/www 