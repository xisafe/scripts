#!/bin/bash
# --------------------------------------------------
#http://blog.51cto.com/kongzi68/1644013
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




#判断IP是否符合标准规则
function judge_ip(){
        #这里local $1出错，用2>/dev/null屏蔽掉错误，暂未发现影响输出结果
        local $1 2>/dev/null
        TMP_TXT=/tmp/iptmp.txt
        echo $1 > ${TMP_TXT}
        IPADDR=`grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' ${TMP_TXT}`
        #判断有没有符合***.***.***.***规则的IP
        if [ ! -z "${IPADDR}" ];then
                local j=0;
                #通过循环来检测每个点之前的数值是否符合要求
                for ((i=1;i<=4;i++))
                do
                        local IP_NUM=`echo "${IPADDR}" |awk -F. "{print $"$i"}"`
                        #判断IP_NUM是否在0与255之间
                        if [ "${IP_NUM}" -ge 0 -a "${IP_NUM}" -le 255 ];then
                                ((j++));
                        else
                                return 1
                        fi
                done
                #通过j的值来确定是否继续匹配规则，循环四次，若都正确j=4.
                if [ "$j" -eq 4 ];then
                        #确认是否为自己想要输入的IP地址
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


read -p "想要设置的IP示例为“192.168.1.1”，请输入：" IPADDRS
judge_ip "${IPADDRS}";
i=`echo $?`
#循环直到输入正确的IP为止
until [ "$i" -eq 0 ];do
    echo -e "\033[31m你输入了错误的IP：${IPADDRS} ====>>>>\033[0m" 
    read -p "重新输入IP，示例“192.168.1.1”，请输入：" IPADDRS
    judge_ip "${IPADDRS}";
    i=`echo $?`
done











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

read -p "请输入IP地址”，请输入：" IPADDRS
Check-IP "${IPADDRS}";
i=`echo $?`
#循环直到输入正确的IP为止
until [ "$i" -eq 0 ];do
    echo -e "\033[31m你输入了错误的IP：${IPADDRS} ====>>>>\033[0m" 
    read -p "请重新输入IP地址：" IPADDRS
    Check-IP "${IPADDRS}";
    i=`echo $?`
done

