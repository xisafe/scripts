
#!/bin/bash
echo 第一个 $1
echo 第二个 $2
echo "第三个 $3"
#显示参数
echo 脚本名 $0
#本身的文件名
echo 传了$#个参数
echo '字符串 $4'
echo $*
#所有参数列表
echo $@
#所有参数列表
echo $$ 
#shell本身的PID
echo $?
#上一个命令结束返回代码(判断true,0/false,1)
