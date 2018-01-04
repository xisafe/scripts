#!/bin/bash
# --------------------------------------------------
#Author:		LGhost
#Email:			admin@attacker.club
#Site:		    blog.attacker.club

#Site:blog.attacker.club  Mail:admin@attacker.club
#Date:2017-10-22 13:49:42 Last:2017-10-22 14:28:00
#Description:	
# --------------------------------------------------






##  常用内核参数

net.ipv4.ip_local_port_range = 9000 65000#被动端口
fs.nr_open = 9999999   #单个进程可分配的最大文件数
fs.file-max = 9999999  #系统级别的能够打开的文件句柄的数量







net.core.rmem_max = 16777216 #接收套接字缓冲区大小的最大值
net.core.wmem_max = 16777216 #发送套接字缓冲区大小的最大值
net.core.netdev_max_backlog = 262144 #每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目
net.core.somaxconn =65535 #用来限制监听(LISTEN)队列最大数据包的数量，超过这个数量就会导致链接超时或者触发重传机制，而nginx定义的NGX_LISTEN_BACKLOG默认为511，所以有必要调整这个值



## 查看tcp状态

netstat -an|awk '/tcp/{++a[$NF]}END{for(i in a)print i,a[i]}'
ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' # 这个查找快
#查看tcp状态

TIME_WAIT 3953
CLOSE_WAIT 17498
FIN_WAIT1 17
FIN_WAIT2 11
ESTABLISHED 2548
SYN_RECV 25
CLOSING 3
LAST_ACK 6586
LISTEN 29




## CLOSE_WAIT
 #TCP发送keepalive探测以确定该连接已经断开的次数



### 暴力
netstat -nap |grep :8009|grep CLOSE_WAIT | awk '{print $7}'|awk -F"\/" '{print $1}' |awk '!a[$1]++'  |xargs kill 
# apache服务器和Tomcat之间的CLOSE_WAIT进程号kill掉

## TIME_WAIT 过多
net.ipv4.tcp_tw_reuse = 1 #开启TCP重用。允许将TIME-WAIT sockets重新用于新的TCP连接

net.ipv4.tcp_fin_timeout = 3 #表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间

net.ipv4.tcp_tw_recycle = 0 #timewait快速回收,面向外网服务关闭此功能
#1.reuse、recycle通过timestamp的递增性来区分是否新连接
#2.很多主机是NAT方式上网同出一个源ip地址,那么这些主机syn请求中timestamp递增性无可保证，服务器会拒绝非递增请求连接(丢弃syn包时间戳小的主机请求)。



### syn防护
net.ipv4.tcp_syncookies = 1 
#正常情况不开启
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
net.ipv4.tcp_max_syn_backlog = 2000
#SYN队列的长度，容纳更多等待连接


## LAST_ACK 过多
net.ipv4.tcp_retries2= 5  #加速处理LAST_ACK，减少等待ACK的LAST_ACK的重试次数
net.ipv4.tcp_orphan_retries = 3 #丢TCP太频繁,后勤都跟不上,设置丢弃之前的重试次数
net.ipv4.tcp_challenge_ack_limit = 1000






## 排查
tcpdump  -i em1   -s0 tcp port 22  and host   43.225.XX.XX   -vv -c 2
# telnet测试端口，服务器抓包是否收到 syn请求；是否发送 ask回应





##TCP keepalive 与 Ngin/apache keepalive
#TCP 的 SO_KEEPALIVE，当网络突然中断时，用来及时探测对端断开，避免无限制阻塞 recv。
#HTTP 的 keepalive，是双方约定长连接、还是收完一次数据后立刻关闭套接字。
