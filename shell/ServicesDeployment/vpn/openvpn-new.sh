#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:31
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





yum install  gcc  pam-devel openssl-devel  git -y

install_lzo ()
{
  cd /usr/local/src/
	wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.06.tar.gz && tar zxvf  lzo-2.06.tar.gz 
	tar zxf  lzo-*.tar.gz
	cd lzo-*
	./configure --prefix=/usr/local/lzo
	make &&make install && cd ..

#lzo-devel
}


install_openvpn ()
{
	#tar zxvf openvpn-*tar.gz && cd  openvpn-*
 # git clone https://github.com/OpenVPN/openvpn.git
    tar zxf  openvpn*.tar.gz
    cd openvpn*
	./configure --prefix=/usr/local/openvpn --with-lzo-lib=/usr/local/lzo/lib \
	--with-lzo-headers=/usr/local/lzo/include
	make && make install 

}


git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3 && cp vars.example  vars


cat >> vars <<EOF
export KEY_COUNTRY="CN"
export KEY_PROVINCE="ZheJiang"
export KEY_CITY="Hangzhou"
export KEY_ORG="Attacker.Club"
export KEY_EMAIL="admin@attacker.club"
export KEY_NAME="OPENVPN"
export KEY_OU="LOGOS"
EOF


sed -i '/^#/d;/^$/d' vars
sed -i '''/KEY_COUNTRY/c export KEY_COUNTRY="CN" '''  vars  #国家
sed -i '''/KEY_PROVINCE/c export KEY_PROVINCE="ZheJiang" ''' vars #省份
sed -i '''/KEY_CITY/c export KEY_CITY="HangZhou" ''' vars #城市
sed -i '''/KEY_ORG/c export KEY_ORG="Attacker" ''' vars #组织
sed -i '''/KEY_EMAIL/c export KEY_EMAIL="admin@attacker.club" ''' vars #邮件
sed -i ''' /KEY_OU/c export KEY_OU="LOGOS" '''  vars #单位



cp vars.example  vars
chmod +x vars

cat >> vars <<EOF
set_var EASYRSA_REQ_COUNTRY "CN"
set_var EASYRSA_REQ_PROVINCE "ZheJiang"
set_var EASYRSA_REQ_CITY "Hangzhou"
set_var EASYRSA_REQ_ORG "Attacker.Club"
set_var EASYRSA_REQ_EMAIL "admin@attacker.club"
set_var EASYRSA_REQ_OU "LOGOS"
EOF

./easyrsa init-pki

./easyrsa build-ca
#输入主机名
./easyrsa gen-req server nopass
#默认
./easyrsa sign server server
#yes,输入ca密码
./easyrsa gen-dh



cp  pki/ca.crt /usr/local/openvpn/
cp  pki/private/server.key  /usr/local/openvpn/
cp  pki/issued/server.crt  /usr/local/openvpn
cp  pki/dh.pem  /usr/local/openvpn/