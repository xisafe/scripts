#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:36
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


Install_docker()
{

  yum install -y yum-utils device-mapper-persistent-data lvm2
  #安装依赖包

  yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
    # 添加Docker软件包源

  yum makecache fast
  # 更新yum包索引
  yum install docker-ce -y
  # 安装Docker CE
  

#设置默认从中国镜像仓库中拉取
  systemctl start docker && systemctl enable docker

}

Install_docker
cat > /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": [ "https://registry.docker-cn.com"]
}
EOF