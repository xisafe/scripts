#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:38
#Description:	
# --------------------------------------------------


if [ $(id -u) != "0" ]; then
    color_message "warn" "Error: please use root account"
    exit 1
fi

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

. include/*
. config/*
#导入配置


cur_dir=$(pwd)
#当前目录

color_message  "info" "---- Environment variable ----"
ntp=""
salt=""
zabbix-agent=""

dnsaddr="223.5.5.5"






date +"%Y%m%d%H%M%S"

#color_message "info" "Modify root passwd"
#echo "123456"|passwd --stdin "root"
case "${action}" in
Init_Install
#开始初始化主机

echo "++++++++++++++++ END To Initialize Server and Reboot Host +++++++++++++++++"

#标准化： 主机名,ip地址,环境