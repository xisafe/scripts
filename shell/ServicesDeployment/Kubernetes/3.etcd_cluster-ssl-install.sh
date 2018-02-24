#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:35
#Description:	3节点：node1、node2、node3
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


function Check-IP(){

        local $1 2>/dev/null
        TMP_TXT=/tmp/iptmp.txt
        echo $1 > ${TMP_TXT}
        IPADDR=`grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' ${TMP_TXT}`
        if [ ! -z "${IPADDR}" ];then
                local j=0;
                for ((i=1;i<=4;i++))
                do
                        local IP_NUM=`echo "${IPADDR}" |awk -F. "{print $"$i"}"`
                        if [ "${IP_NUM}" -ge 0 -a "${IP_NUM}" -le 255 ];then
                                ((j++));
                        else
                                return 1
                        fi
                done
                if [ "$j" -eq 4 ];then

            read -n 1 -p "你输入的IP是${IPADDR},确认输入：Y|y；重新输入：R|r：" OK
            case ${OK} in
                        Y|y) return 0;;
                R|r) return 1;;
                *) return 1;;
            esac
                else
                        return 1
                fi
        else
                return 1
        fi
}    



read -p "请输入本节点etcd名(node1...)，请输入：" node
echo 




read -p "请输入etcd-node1主机IP，请输入：" node1ip
Check-IP "${node1ip}";
i=`echo $?`
#循环直到输入正确的IP为止
until [ "$i" -eq 0 ];do
    echo -e "\033[31m你输入了错误的IP：${node1ip} ====>>>>\033[0m" 
    read -p "请重新输入node1地址：" node1ip
    Check-IP "${node1ip}";
    i=`echo $?`
done
echo

read -p "请输入etcd-node2主机IP，请输入：" node2ip
Check-IP "${node2ip}";
i=`echo $?`
#循环直到输入正确的IP为止
until [ "$i" -eq 0 ];do
    echo -e "\033[31m你输入了错误的IP：${node2ip} ====>>>>\033[0m" 
    read -p "请重新输入node2地址：" node2ip
    Check-IP "${node2ip}";
    i=`echo $?`
done
echo


read -p "请输入etcd-node3主机IP，请输入：" node3ip
Check-IP "${node3ip}";
i=`echo $?`
#循环直到输入正确的IP为止
until [ "$i" -eq 0 ];do
    echo -e "\033[31m你输入了错误的IP：${node3ip} ====>>>>\033[0m" 
    read -p "请重新输入node3地址：" node3ip
    Check-IP "${node3ip}";
    i=`echo $?`
done



wan=$(route |grep default|awk '{print $8}')
if [ -z $wan ];then
  wan="eth0"
fi
ipaddr=`ifconfig  $wan |grep -vw lo |awk -F '[ /]+'  '/inet/ {print $3}'`

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




Install_etcd()
{
  if [ -f etcd-*tar.gz ] ;then


    #wget -O etcd-3.2.13.tar.gz https://codeload.github.com/coreos/etcd/tar.gz/v3.2.13
    tar zxvf etcd-*tar.gz
    mv  etcd-*/{etcd,etcdctl}  /usr/bin/
    chown root:root  /usr/bin/{etcd,etcdctl}
    mkdir -p /data/etcd

  fi


cat > /etc/sysconfig/etcd <<EOF
ETCD_NAME=$node
ETCD_DATA_DIR="/data/etcd/defualt"
ETCD_LISTEN_PEER_URLS="https://$ipaddr:2380"
ETCD_LISTEN_CLIENT_URLS="https://$ipaddr:2379,https://127.0.0.1:2379"

#[Clustering]
ETCD_ADVERTISE_CLIENT_URLS="https://$ipaddr:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://$ipaddr:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster1"
ETCD_INITIAL_CLUSTER="node1=https://$node1ip:2380,node2=https://$node2ip:2380,node3=https://$node3ip:2380"
EOF

cat > /usr/lib/systemd/system/etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/data/etcd
EnvironmentFile=-/etc/sysconfig/etcd

# set GOMAXPROCS to number of processors
ExecStart=/usr/bin/etcd \\
--name=\${ETCD_NAME} \\
--data-dir=\${ETCD_DATA_DIR} \\
--listen-peer-urls=\${ETCD_LISTEN_PEER_URLS} \\
--listen-client-urls=\${ETCD_LISTEN_CLIENT_URLS} \\
--advertise-client-urls=\${ETCD_ADVERTISE_CLIENT_URLS} \\
--initial-advertise-peer-urls=\${ETCD_INITIAL_ADVERTISE_PEER_URLS} \\
--initial-cluster=\${ETCD_INITIAL_CLUSTER} \\
--initial-cluster-token=\${ETCD_INITIAL_CLUSTER} \\
--initial-cluster-state=\${ETCD_INITIAL_CLUSTER_STATE} \\
--cert-file=/opt/kubernetes/ssl/server.pem \\
--key-file=/opt/kubernetes/ssl/server-key.pem \\
--peer-cert-file=/opt/kubernetes/ssl/server.pem \\
--peer-key-file=/opt/kubernetes/ssl/server-key.pem \\
--trusted-ca-file=/opt/kubernetes/ssl/ca.pem \\
--peer-trusted-ca-file=/opt/kubernetes/ssl/ca.pem


Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload && systemctl start etcd && systemctl enable etcd

    #etcdctl member list 
    #etcdctl cluster-health
    #查看状态

}


Install_etcd

