
cat >>/etc/openvpn/server.conf <<EOF
local 0.0.0.0
port 1194
proto tcp
dev tun

ifconfig-pool-persist ipp.txt
keepalive 10 120
#cipher AES-256-CBC
comp-lzo
persist-key
persist-tun

#秘钥文件
ca /etc/openvpn/easy-rsa/2.0/keys/ca.crt
cert /etc/openvpn/easy-rsa/2.0/keys/server.crt
key /etc/openvpn/easy-rsa/2.0/keys/server.key  
dh /etc/openvpn/easy-rsa/2.0/keys/dh2048.pem

#日志设置
verb 3
status /etc/openvpn/openvpn-status.log
log   /etc/openvpn/openvpn.log
log-append  /etc/openvpn/openvpn.log

#本地登录
script-security 3
client-cert-not-required
username-as-common-name
auth-user-pass-verify /etc/openvpn/checkpwd.sh via-env

#网络下发
push "dhcp-option DNS 223.5.5.5"
#下发DNS
server 10.8.0.0 255.255.255.0
#分配客户端的IP地址段
EOF
#新建openvpn配置文件
