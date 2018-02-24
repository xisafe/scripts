#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:   admin@attacker.club


#Last Modified: 2018-02-24 18:04:38
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





Yum_install ()
{
	color_message  "info" "---- yum install ----"
yum update -y
#Update all packages
yum install gcc gcc-c++   openssl-devel  ntpdate nfs-utils \
openssl-perl ncurses-devel pcre-devel zlib zlib-devel unzip -y
#base 
yum install  nmap iotop sysstat iftop nload  net-tools lrzsz \
wget  vim-enhanced  mlocate  lsof   -y
#tools
yum install OpenIPMI OpenIPMI-devel OpenIPMI-tools OpenIPMI-libs -y
#ipmi
}

Set_hostname()
{
	if [ $# -lt 1 ]; then
		color_message  "warn"  "---- no set hostname ----"
		HOSTNAME="TemplateOS"
    else
    	HOSTNAME=$1
    fi
    	sed -i "/HOSTNAME/c HOSTNAME=$HOSTNAME" /etc/sysconfig/network||echo "HOSTNAME=$HOSTNAME" >>/etc/sysconfig/network 
    	echo "$HOSTNAME" > /etc/hostname
    hostname $HOSTNAME
}


Set_Selinux()
{
	color_message  "info" "---- close  selinux ----"
    if [ -s /etc/selinux/config ]; then
    	setenforce 0
        sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
    fi
}


Set_iptables()
{
	color_message  "info"  "---- setup iptables ----"
	if [ ! -f /etc/sysconfig/iptables  ];then
		yum install  iptables-services -y
		chkconfig iptables on
		systemctl enable  iptables
		systemctl disable  firewalld
		systemctl stop  firewalld
		service iptables restart
	fi

	iptables -F
	iptables -X
	iptables -t nat -F
	iptables -t nat -X
	iptables-save
	service iptables save
}


Centos_init()
{
	
	rhel_version=`awk '{print $4}'  /etc/redhat-release |cut -c 1`
	#系统版本
	if [ $rhel_version = 7 ] ;then
	#set network
	mv  /etc/sysconfig/network-scripts/ifcfg-$WAN  /etc/sysconfig/network-scripts/ifcfg-eth0
	cp /etc/sysconfig/grub /etc/sysconfig/grub.bak 
	grub2-mkconfig -o /boot/grub2/grub.cfg
	#  net.ifnames=0 biosdevname=0
	systemctl  disable  NetworkManager
	systemctl  stop  NetworkManager
	fi
}


Set_IP()
{

color_message  "info"  "static IPAddress"
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
PEERDNS=yes
USERCTL=no
NM_CONTROLLED=no
MTU=1454
IPADDR=$IPADDR
NETMASK=$NETMASK
GATEWAY=$GATEWAY
$HWADDR
EOF
}


Set_dns()
{
color_message  "info"  "dns"
sed -i    "/nameserver/d;a nameserver ${dnsaddr}" /etc/resolv.conf

}
Set_timezone()
{
	\cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}


dmidecode -s system-product-name|awk '{if($1!~"VMware")exit 1}' || hwclock -w

Set_ssh()
{
color_message  "info" "SSH"
sed -i "s/#UseDNS yes/UseDNS no/g" `grep '#UseDNS yes' -rl /etc/ssh/sshd_config`
sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" `grep '#AuthorizedKeysFile' -rl /etc/ssh/sshd_config`
sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/g" `grep 'GSSAPIAuthentication yes' -rl /etc/ssh/sshd_config`	
}


Set_limits()
{
color_message  "info"  "limits"
chmod +x /etc/rc.local ; grep ulimit  /etc/rc.local || echo ulimit -HSn 1048576 >>/etc/rc.local
grep  1048576 /etc/security/limits.conf ||cat >>/etc/security/limits.conf<<EOF
* soft nproc 1048576
* hard nproc 1048576
* soft nofile 1048576
* hard nofile 1048576
EOF
}

Set_profile()
{
color_message  "info" "profile"
grep vi ~/.bashrc || sed  -i  "/mv/a\alias vi='vim'"  ~/.bashrc
grep PS /etc/profile || echo '''PS1="\[\e[37;1m\][\[\e[32;1m\]\u\[\e[37;40m\]@\[\e[34;1m\]\h \[\e[0m\]\t \[\e[35;1m\]\W\[\e[37;1m\]]\[\e[m\]/\\$" ''' >>/etc/profile
grep HISTTIMEFORMAT  /etc/profile || echo ''' export HISTTIMEFORMAT="%F %T `whoami`" ''' >>/etc/profile
}

optimize_kernel()
{
color_message  "info"  "kernel optimize "
grep 65535 /etc/sysctl.conf || cat >> /etc/sysctl.conf<<EOF
fs.file-max = 9999999
fs.nr_open = 9999999
net.ipv4.ip_local_port_range = 9000 65000

net.ipv4.tcp_keepalive_time = 180
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5

net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 3
net.ipv4.tcp_tw_recycle = 1

net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
EOF
sysctl -p
}
