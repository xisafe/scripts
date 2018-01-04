#!/bin/bash

which wget &>/dev/null  || yum install wget -y 

function install_yum (){
read -n1 -p "你的系统是Centos6还是7 ?": number
case $number in
6 | 7)
mkdir  /etc/yum.repos.d/tmp
mv /etc/yum.repos.d/*.repo  /etc/yum.repos.d/tmp
wget -P /etc/yum.repos.d  http://list.attacker.club/4.config/yum/centos${number}.repo &>/dev/null
yum clean all;;

*)
   
   echo  -e "\n\n\033[41;36m 输入错误，请选择数字: 6或7 \033[0m\n";;

esac
}





install_yum 
