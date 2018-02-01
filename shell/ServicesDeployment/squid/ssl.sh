#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-30 21:58:00
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




#创建CA
cat >  ca-config.json <<EOF
{
	"signing": {
		"default": {
			"expiry": "87600h"
		},
		"profiles": {
			"Attacker": {
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

#创建 CA 证书签名请求
cat >  ca-csr.json <<EOF
{
	"CN": "Attacker",
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

cfssl gencert -initca ca-csr.json | cfssljson -bare ca -

#创建Attacker证书
cat > server-csr.json <<EOF
{
    "CN": "Attacker",
    "hosts": [
      "127.0.0.1",
      "www.attacker.club"
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

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=Attacker server-csr.json | cfssljson -bare server
