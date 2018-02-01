#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-31 18:09:14
#Description:	 CentOS 6  install openvpn
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
  read -p 'Are you sure to Continue? [Y/N]:' answer
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
#确认运行脚本


yum install  gcc openssl-devel  git -y

install_lzo ()
{
  cd /usr/local/src/
	wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.06.tar.gz && tar zxvf  lzo-2.06.tar.gz 
	cd lzo-*
	./configure --prefix=/usr/local/lzo
	make &&make install && cd ..
#lzo-devel
}

install_openvpn ()
{
	#tar zxvf openvpn-*tar.gz && cd  openvpn-*
 # git clone https://github.com/OpenVPN/openvpn.git
  cd openvpn*
	./configure --prefix=/usr/local/openvpn --with-lzo-lib=/usr/local/lzo/lib \
	--with-lzo-headers=/usr/local/lzo/include
	make && make install 

}

if [ ! -d /usr/local/lzo ] ;then
	install_lzo

fi

if [ ! -d  /usr/local/openvpn ] ;then
	install_openvpn
fi


cat >/usr/local/openvpn/server.conf <<EOF
#static routes
push "route 192.168.8.0   255.255.252.0"

#network
dev tun
proto tcp
port 1194
local 0.0.0.0

push "dhcp-option DNS 223.5.5.5"
server 172.8.0.0 255.255.255.0 
management localhost 7505 #management

ifconfig-pool-persist ipp.txt

comp-lzo
persist-key
persist-tun
duplicate-cn
max-clients 1000
keepalive 10 7200

#key
ca ca.crt
dh dh2048.pem
key server.key
cert server.crt

#log
verb 3

log   /usr/local/openvpn/openvpn.log
log-append /usr/local/openvpn/openvpn.log
status /usr/local/openvpn/openvpn-status.log

#本地登录
script-security 3
username-as-common-name
client-cert-not-required
auth-user-pass-verify /usr/local/openvpn/checkpwd.sh via-env
EOF

PASSFILE="/usr/local/openvpn/passwd"
LOG_FILE="/usr/local/openvpn/password.log"
TIME_STAMP=`date "+%Y-%m-%d %T"`
if [ ! -r "${PASSFILE}" ]; then
  echo "${TIME_STAMP}: Could not open password file \"${PASSFILE}\" for reading." >> ${LOG_FILE}
  exit 1
fi

CORRECT_PASSWORD=`awk '!/^;/&&!/^#/&&$1=="'${username}'"{print $2;exit}' ${PASSFILE}`

if [ "${CORRECT_PASSWORD}" = "" ]; then
  echo "${TIME_STAMP}: User does not exist: username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
  exit 1
fi

if [ "${password}" = "${CORRECT_PASSWORD}" ]; then
  echo "${TIME_STAMP}: Successful authentication: username=\"${username}\"." >> ${LOG_FILE}
  exit 0
fi

echo "${TIME_STAMP}: Incorrect password: username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
exit 1



echo  'lj 666666' >>/usr/local/openvpn/passwd
chmod +x  /usr/local/openvpn/checkpwd.sh


yum -y install easy-rsa 
cd /usr/share/easy-rsa/2.0/
sed -i '/^#/d;/^$/d' vars


sed -i '''/KEY_COUNTRY/c export KEY_COUNTRY="CN" '''  vars  #国家
sed -i '''/KEY_PROVINCE/c export KEY_PROVINCE="ZheJiang" ''' vars #省份
sed -i '''/KEY_CITY/c export KEY_CITY="HangZhou" ''' vars #城市
sed -i '''/KEY_ORG/c export KEY_ORG="Attacker" ''' vars #组织
sed -i '''/KEY_EMAIL/c export KEY_EMAIL="admin@attacker.club" ''' vars #邮件
sed -i ''' /KEY_OU/c export KEY_OU="LOGOS" '''  vars #单位


source vars
./clean-all
./build-ca server
./build-key-server server
./build-key client
./build-dh

cd /usr/local/openvpn
nohup /usr/local/openvpn/sbin/openvpn  --config /usr/local/openvpn/server.conf  &


echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING  -j MASQUERADE
iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200 
