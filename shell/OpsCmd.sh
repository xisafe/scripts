## 运维常用命令

http://blog.csdn.net/a519640026/article/details/76157948
http://www.linuxde.net/2011/09/721.html

### 连接数查看
netstat -an | awk '/^tcp/ {print $6}'|sort |uniq -c|sort -n
#查看当前TCP连接状态

ss -an|awk '{print $5}'|awk -F: '{print $1}'|sort|egrep -o '[0-9]{1,3}(\.[0-9]{1,3}){3}'|uniq -c|sort -nr|head -n 10
#查看并发最多的独立IP，取其前10个；sort排序 参数nr中n是按照排序大小，r是反向排序。uniq -c计数显示

watch 'netstat -an | egrep -w "80|443"|grep ESTABLISHED |wc -l'
#查看http web连接数
