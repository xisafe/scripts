#!/bin/bash
# --------------------------------------------------
#Author:  LGhost
#Email:   admin@attacker.club
#Site:    blog.attacker.club

#Last Modified: 2018-01-31 22:27:59
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



Init_Install()
{
  Yum_install
  Set_hostname $1
  Set_Selinux
  Set_iptables
  Centos_init
  #Set_IP
  Set_dns
  Set_ssh
  Set_limits
  Set_profile
  Set_timezone
  optimize_kernel
}



Yum_install ()
{
  color_message  "info" "---- yum install ----"
  yum update -y
  #Update all packages
  yum install gcc gcc-c++   openssl-devel  ntpdate nfs-utils \
  openssl-perl ncurses-devel pcre-devel zlib zlib-devel unzip -y
  #base 
  yum install  nmap iotop sysstat dstat iftop nload  iproute net-tools  \
  lrzsz wget vim-enhanced  mlocate  lsof telnet  yum-utils  dmidecode -y
  #tools
  yum install OpenIPMI OpenIPMI-devel OpenIPMI-tools OpenIPMI-libs -y
  #ipmi
}

Set_hostname()
{
  #bash host_init.sh hostname 主机名传参
  if [ $# -lt 1 ]; then
    #传参少于1个
    color_message  "warn"  "---- no set hostname ----"
    HOSTNAME="TemplateOS"
    #默认主机名TemplateOS
  else
      HOSTNAME=$1
  fi

  if [ -d /etc/hostname ];then
      echo "$HOSTNAME" > /etc/hostname
  fi
  sed -i "/HOSTNAME/c HOSTNAME=$HOSTNAME" /etc/sysconfig/network||echo "HOSTNAME=$HOSTNAME" >>/etc/sysconfig/network
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
  rhel_version=`grep -oP  '\d'   /etc/redhat-release|head -1`
  #系统版本
  if [ $rhel_version = 6 ] ;then
    echo  > /etc/udev/rules.d/70-persistent-net.rules &>/dev/null
  fi

  if [ $rhel_version = 7 ] ;then
    cp /etc/sysconfig/grub /etc/sysconfig/grub.bak 
    grub2-mkconfig -o /boot/grub2/grub.cfg
    #  net.ifnames=0 biosdevname=0
    systemctl  disable  NetworkManager
    systemctl  stop  NetworkManager
    echo > /etc/udev/rules.d/90-eno-fix.rules &>/dev/null
  fi
}


Set_IP()
{
  color_message  "info"  "static IPAddress"
  WAN=$(route |grep default|head -1|awk '{print $NF}') 
  #外网出接口
  IPADDR=`ifconfig $WAN |grep inet|awk '{print $2}'`
  NETMASK=`ifconfig $WAN |grep inet|awk '{print $4}'`
  GATEWAY=`route |grep default| awk '{print $2}'`
  HWADDR=`ifconfig  $WAN  | awk '/ether/ {print "HWADDR="$2}'` 
  interface=`ifconfig -a |grep mtu|grep -v $WAN|grep -v lo|awk -F: '{print $1}'`
  ifcfg="/etc/sysconfig/network-scripts/ifcfg-eth"



mv  /etc/sysconfig/network-scripts/ifcfg-$WAN  ${ifcfg}0
cat > ${ifcfg}0 <<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
MTU=1454
EOF

if [ ! -z $IPADDR ];then  #变量值非空
  num=0 #计数
  for i in $interface
  #接口列表循环
  do
    let  num=$num+1

    mv  /etc/sysconfig/network-scripts/ifcfg-$i ${ifcfg}$num
    cat  ${ifcfg}0 > ${ifcfg}$num
    sed -i "s/eth0/eth$num/" ${ifcfg}$num
    echo `ifconfig  $i  | awk '/ether/ {print "HWADDR="$2}'` >> ${ifcfg}$num
    #除网卡1其他都自动获取地址
  done
fi

if [ ! -z $IPADDR ]; then   
  sed -i "s/dhcp/static/"  ${ifcfg}0
  echo "IPADDR=$IPADDR" >>  ${ifcfg}0
  echo "NETMASK=$NETMASK" >>  ${ifcfg}0
  echo "GATEWAY=$GATEWAY" >>  ${ifcfg}0
  echo "$HWADDR" >>  ${ifcfg}0
  #给网卡1配置静态地址
fi  

}


Set_dns()
{
  color_message  "info"  "dns"
  dnsaddr='223.5.5.5'
  sed -i    "/nameserver/d;a nameserver ${dnsaddr}" /etc/resolv.conf
}

Set_timezone()
{
  \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  dmidecode -s system-product-name|awk '{if($1!~"VMware")exit 1}' || hwclock -w
}




Set_ssh()
{
  color_message  "info" "SSH"
  sed -i "s/#UseDNS yes/UseDNS no/g" `grep '#UseDNS yes' -rl /etc/ssh/sshd_config` &>/dev/null
  sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/" `grep '#AuthorizedKeysFile' -rl /etc/ssh/sshd_config` &>/dev/null
  sed -i "s/GSSAPIAuthentication yes/GSSAPIAuthentication no/g" `grep 'GSSAPIAuthentication yes' -rl /etc/ssh/sshd_config` &>/dev/null  
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
  grep HISTTIMEFORMAT  /etc/profile || echo '''export HISTTIMEFORMAT="%F %T `whoami` " ''' >>/etc/profile
}

optimize_kernel()
{
  color_message  "info"  "kernel optimize "

grep 65535 /etc/sysctl.conf || cat > /etc/sysctl.conf<<EOF
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




Init_Install $1
#调用执行

#echo "tmp123456"|passwd --stdin "root" #修改密码
echo "++++++++++++++++ END To Initialize Server  +++++++++++++++++"


