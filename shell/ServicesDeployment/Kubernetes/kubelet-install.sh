#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-29 01:29:01
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



DNS_SERVER_IP=${1:-"10.10.10.2"}
KUBECONFIG_DIR=${KUBECONFIG_DIR:-/opt/kubernetes/cfg}


wan=$(route |grep default|awk '{print $8}')
if [ -z $wan ];then
  wan="eth0"
fi
NODE_ADDRESS=`ifconfig  $wan |grep -vw lo |awk -F '[ /]+'  '/inet/ {print $3}'`


read -p "请输入kubernetesAPI服务器ip地址：" MASTER_ADDRESS
echo 







cat <<EOF > "${KUBECONFIG_DIR}/kubelet.kubeconfig"
apiVersion: v1
kind: Config
clusters:
  - cluster:
      server: http://${MASTER_ADDRESS}:8080/
    name: local
contexts:
  - context:
      cluster: local
    name: local
current-context: local
EOF

cat <<EOF >/opt/kubernetes/cfg/kubelet

KUBELET_OPTS="--logtostderr=true \\
--v=4 \\
--address=${NODE_ADDRESS} \\
--hostname-override=${NODE_ADDRESS} \\
--kubeconfig=${KUBECONFIG_DIR}/kubelet.kubeconfig \\
--allow-privileged=false \\
--cluster-dns=${DNS_SERVER_IP} \\
--cluster-domain=cluster.local \\
--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0"

# 启用日志标准错误
# 日志级别 
# Kubelet服务IP地址 
# 自定义节点名称
# kubeconfig路径，指定连接API服务器
# 允许容器请求特权模式，默认false
# DNS信息

EOF

cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.service
Requires=docker.service

[Service]
EnvironmentFile=-/opt/kubernetes/cfg/kubelet
ExecStart=/opt/kubernetes/bin/kubelet \$KUBELET_OPTS
Restart=on-failure
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet