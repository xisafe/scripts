1. 检查帐户

awk -F: '$3==0 {print $1}' /etc/passwd
#查看是否存在特权用户
awk -F: 'length($2)==0 {print $1}' /etc/shadow
#查看是否存在空口令帐户
awk -F\: '{system("passwd -S "$1)}' /etc/passwd|awk '{print $1,$3}'
#查看账户创建日期



2. 检查日志
# last（查看正常情况下登录到本机的所有用户的历史记录）
注意”entered promiscuous mode”
注意错误信息
注 意Remote Procedure Call (rpc) programs with a log entry that includes a large number (> 20) strange characters(-^PM-^PM-^PM-^PM-^PM-^PM-^PM-^PM)

3. 检查进程
ps -aux  #注意UID是0的
lsof -p pid  #察看该进程所打开端口和文件
#cat /etc/inetd.conf | grep -v “^#”（检查守护进程）
检查隐藏进程
ps -ef|awk '{print }'  |sort -n|uniq >1
ls /proc |sort -n |uniq >2
diff 1 2


4. 检查文件
find / -uid 0 -perm -4000 -print
find / -size +10000k -print|  xargs  du -sh|sort -nr #10M以上的文件
find / -name “…” -print
find / -name “.. ” -print
find / -name “. ” -print
find / -name ” ” -print
注意SUID文件，可疑大于10M和空格文件
find / -name core -exec ls -l {} ;（检查系统中的core文件）

检查系统文件完整性
rpm -qf /bin/ls
rpm -qf /bin/login
md5sum -b 文件名
md5sum -t 文件名

5. 检查RPM

which ps |grep bin 2> /dev/null |xargs rpm -qf &> /dev/null && echo normal || echo  change
which cd |grep bin 2> /dev/null |xargs rpm -qf &> /dev/null && echo normal || echo  change
which ls |grep bin 2> /dev/null |xargs rpm -qf &> /dev/null && echo normal || echo  change
which lsof |grep bin 2> /dev/null |xargs rpm -qf &> /dev/null && echo normal || echo  change
which lsof |grep bin 2> /dev/null |xargs rpm -qf &> /dev/null && echo normal || echo  change
which netstat |grep bin 2> /dev/null |xargs rpm -qf &> /dev/null && echo normal || echo  change
#常用命令检查

6. 检查网络
ip link | grep PROMISC #正常网卡不该在promisc模式，可能存在sniffer
lsof -i
netstat -pltu #TCP/UDP服务端口检查
arp -a #arp 地址

7. 检查计划任务

crontab -u root  -l
#查看指定用户是否有计划任务
cat /etc/crontab
#查看计划任务配置
ls -l /etc/cron.*
#查看计划任务创建的时间
ls /var/spool/cron/
#查看计划任务账号

8. 检查启动项
cat /etc/rc.d/rc.local
ls /etc/rc.d
ls /etc/rc3.d
find / -type f -perm 4000

9. 检查内核模块
lsmod

10. 检查系统服务
chkconfig
systemctl
rpcinfo -p #查看RPC服务(nfs)

11. 检查rootkit
rkhunter -c
chkrootkit -q

