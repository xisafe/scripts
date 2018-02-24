#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:34
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

read -p "请输入etcd集群ip地址，请输入：" etcdnode
echo 
curl -s  $etcdnode:2379/v2/members || echo "etcd cannot access !"



wan=$(route |grep default|awk '{print $8}')
if [ -z $wan ];then
  wan="eth0"
fi
ipaddr=`ifconfig  $wan |grep -vw lo |awk -F '[ /]+'  '/inet/ {print $3}'`



cat <<EOF >/opt/kubernetes/cfg/kube-apiserver

KUBE_APISERVER_OPTS="--logtostderr=true \\
--v=4 \\
--etcd-servers=${etcdnode} \\
--insecure-bind-address=0.0.0.0 \\
--insecure-port=8080 \\
--advertise-address=${ipaddr} \\
--allow-privileged=false \\
--service-cluster-ip-range=10.10.10.0/24 \\
--admission-control=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota,NodeRestriction \
--authorization-mode=RBAC,Node \\
--service-node-port-range=30000-50000 "

# 启用日志标准错误
# 日志级别
# Etcd服务地址
# API服务监听地址
# API服务监听端口
# 对集群中成员提供API服务地址
# 允许容器请求特权模式，默认false
# 集群分配的IP范围
# 控制资源进入集群
# 指定node端口范围
EOF

cat <<EOF >/usr/lib/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=-/opt/kubernetes/cfg/kube-apiserver
ExecStart=/opt/kubernetes/bin/kube-apiserver \$KUBE_APISERVER_OPTS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl restart kube-apiserver