#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-11-22 19:00:16
#Description:	
# --------------------------------------------------

##  变量输入
read -p "Enter your name:" name
echo "hello $name, welcome to my program"
#最简单形式，将输入的数据放入变量中


## 计时器
if read -t 5 -p "please enter your name:" name
	then
	echo "hello $name ,welcome to my script"
else
    echo "sorry,too slow"
fi
exit 0
#-t选项指定read命令等待输入的秒数。当计时满时，read命令返回一个非零退出状态;


## 预设内容

#!/bin/bash
read -n1 -p "Do you want to continue [Y/N]?" answer
case $answer in
Y | y)
      echo "fine ,continue";;
N | n)
      echo "ok,good bye";;
*)
     echo "error choice";;
esac
exit 0
#使用了-n选项，后接数值1，限制输入的字符长度


{Custom-Template  Agent and Ping:icmpping.max(#3)}=0