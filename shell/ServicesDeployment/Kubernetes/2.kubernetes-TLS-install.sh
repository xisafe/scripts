#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-02-01 21:24:57
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


#read -p "请输入etcd集群ip地址，请输入：" etcdnode
#echo 



#创建CA证书
cat >  ca-config.json <<EOF
{
	"signing": {
		"default": {
			"expiry": "87600h"
		},
		"profiles": {
			"kubernetes": {
				"expiry": "87600h",
				"usages": [
				"signing",
				"key encipherment",
				"server auth",
				"client auth"
				]
			}
		}
	}
}
EOF

#创建 CA证书签名请求
cat >  ca-csr.json <<EOF
{
	"CN": "kubernetes",
	"key": {
		"algo": "rsa",
		"size": 2048
	},
	"names": [
	{
		"C": "CN",
		"L": "Hangzhou",
		"ST": "Hangzhou",
		"O": "k8s",
		"OU": "System"
	}
	]
}
EOF
#

cfssl gencert -initca ca-csr.json | cfssljson -bare ca 




#创建kubernetes证书
cat > server-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
      "127.0.0.1",
      "10.10.10.1",
      "192.168.0.10",
      "192.168.0.11",
      "192.168.0.11",
      "192.168.0.107",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Hangzhou",
            "ST": "Hangzhou",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF
#本机,kubernetes集群、etcd相关地址ip

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare server



##创建admin证书
cat > admin-csr.json <<EOF
{
	"CN": "admin",
	"hosts": [],
	"key": {
		"algo": "rsa",
		"size": 2048
	},
	"names": [
	{
		"C": "CN",
		"L": "Hangzhou",
		"ST": "Hangzhou",
		"O": "system:masters",
		"OU": "System"
	}
	]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin

#-----------------------

#创建kube-proxy证书
cat > kube-proxy-csr.json <<EOF
{
	"CN": "system:kube-proxy",
	"hosts": [],
	"key": {
		"algo": "rsa",
		"size": 2048
	},
	"names": [
	{
		"C": "CN",
		"L": "Hangzhou",
		"ST": "Hangzhou",
		"O": "k8s",
		"OU": "System"
	}
	]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy

mkdir -p /opt/kubernetes/{bin,cfg,ssl}
#创建k8s配置目录

cp *pem /opt/kubernetes/ssl/
#拷贝到配置目录

