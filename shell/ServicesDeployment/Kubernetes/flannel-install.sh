
#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-26 15:57:23
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







wan=$(route |grep default|awk '{print $8}')
if [ -z $wan ];then
  wan="eth0"
fi
ipaddr=`ifconfig  $wan |grep -vw lo |awk -F '[ /]+'  '/inet/ {print $3}'`




Install_Flannel()
{
  etcdctl -endpoint="$ipaddr" \
  set /coreos.com/network/config '{ "Network": "172.17.0.0/16", "Backend": {"Type": "vxlan"}}'

  if [ -f flannel-*tar.gz ] ;then
    tar zxvf flannel-*tar.gz
    chown root:root flanneld mk-docker-opts.sh
    mv flanneld mk-docker-opts.sh /usr/bin
  fi

cat > /etc/sysconfig/flanneld <<EOF
FLANNEL_OPTIONS="--etcd-endpoints=http://$ipaddr:2379  --ip-masq=true"
EOF

cat > /usr/lib/systemd/system/flanneld.service <<EOF
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
Before=docker.service

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/flanneld
ExecStart=/usr/bin/flanneld  $FLANNEL_OPTIONS
ExecStartPost=/usr/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/subnet.env
Restart=on-failure

[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
EOF
    systemctl daemon-reload &&   systemctl enable flanneld  
    systemctl start flanneld && systemctl restart docker

}