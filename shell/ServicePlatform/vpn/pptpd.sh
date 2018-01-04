#/bin/bash

wan=$(route |grep default|awk '{print $8}')
#出接口

if [ ! -f /etc/sysconfig/iptables  ];then
        echo -e "\n\t\t\t\t\033[41;33m 安装失败！请先安装iptables-services  \033[0m\n"
        exit 1;
fi

###防火墙策略###
iptables -A POSTROUTING -t nat -s 10.88.88.0/24 -o $wan -j MASQUERADE
iptables -A FORWARD -s 10.88.88.0/24 -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200
#NAT路由、出接口进行MASQUERADE欺骗;设置分段数据大小
iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
#PPTPD端口放行
iptables -A INPUT -p gre  -j ACCEPT
#GRE端口打开
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
#允许DNS服务端口的tcp数据包流入
iptables -A INPUT -p udp --dport 53 -j ACCEPT
#允许DNS服务端口的udp数据包流入
echo 1 > /proc/sys/net/ipv4/ip_forward 
grep  ip_forward  /etc/sysctl.conf &>/dev/null || echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
#开启NAT转发
iptables-save &>/dev/null
service iptables save &>/dev/null
#保存iptable防火墙配置到本地

###安装pptpd服务###
yum remove ppp  pptpd -y &>/dev/null
yum install  ppp  pptpd -y &>/dev/null
#卸载和安装pptd服务

echo localip 10.88.88.1 >>/etc/pptpd.conf
echo remoteip 10.88.88.2-80 >>/etc/pptpd.conf
#拨号地址池

cat  >> /etc/ppp/options.pptpd <<EOF
auth
debug
idle 2592000
#72个小时空闲断开

ms-dns 8.8.8.8       
ms-dns 233.5.5.5

EOF
echo -e 'admin pptpd passwd123 *' >> /etc/ppp/chap-secrets
#添加账号密码

systemctl restart pptpd 
#启动pptpd服务
echo -e "\n\n账号配置文件:"
ls /etc/ppp/chap-secrets
echo -e "\n\033[41;33m 账号密码: \033[0m\n"
awk  'NR>2 {print $1,$3}' /etc/ppp/chap-secrets
#账号文件
