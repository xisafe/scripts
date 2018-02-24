#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:04:30
#Description:	
# --------------------------------------------------


## 格式：
echo -e "\033[字背景颜色; 字体颜色 m 字符串 \ 033[0m"


echo -e "\n\t\t\t\t\033[41;36m 安装成功 \033[0m\n"
#其中41的位置代表底色, 36的位置是代表字的颜色;\n 空行,\t空格
echo -e "\n\t\t\t\t\e[44;37m 安装成功 \e[0m\n"
#蓝底白字
echo -en "\t\t\t\t\e[43;31m\e[05m 失败了 \e[0m"
#不换行黄底红字闪烁
echo -e "\e[31m \e[05m 请确认您的操作,输入 [Y/N] \e[0m"
#闪烁等待
echo -e "\e[1;31m红色警告\e[0m"
echo -e "\e[1;33m黄色提示\e[0m"

#more：http://blog.attacker.club/Linux/echo.html