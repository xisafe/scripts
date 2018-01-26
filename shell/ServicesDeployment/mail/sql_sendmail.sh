#!/bin/bash
#执行程序
mysql=/usr/local/mysql/bin/mysql
Email=/opt/sendEmail

#http://blog.attacker.club/运维/SendEmail.html
smtp=smtp.attacker.club #stmp服务器
user=XXX@attacker.club  #发件人账号
passwd='xxxxxx'			#发件人密码
to=admin@attacker.club  #通知邮箱


#SELECT 查询
function select_comments () {
title=`$mysql -hblog.attacker.club  -uwroot  -ppasswd -e \
'SELECT title
 FROM www.Typechodb_contents
 WHERE cid IN (
        select t.cid from (
                SELECT cid FROM www.Typechodb_comments order  by  coid  desc LIMIT 1) AS t )'|awk NR==2`
#in里面使用limit执行不了，又套了一层;取评论关联的CID,找文章表标题
body=`$mysql -hblog.attacker.club  -uwroot  -ppasswd -e \
 'select  text from www.Typechodb_comments  order  by  coid  desc LIMIT 1'|awk NR==2`
}



#添加对比文件
old_file=/home/mail/record.txt
if [ ! -f $old_file  ]; then
    echo 0  >  $old_file
fi
old=`cat $old_file`

#最新评论数
new=`$mysql -hblog.attacker.club  -uwroot  -ppasswd -e \
 'select  COUNT(cid) from www.Typechodb_comments'|grep -P '\d'`
old=`cat $old_file`



#对比评论数有变化则发送邮件
if [ $new -ne $old ]; then
  echo "$new" >  $old_file
  select_comments &>/dev/null
  $Email  -f $user -s $smtp -xu $user -xp $passwd  -t "$to"    -u "$title"  -m "评论内容:  $body"  -o message-content-type=html   -o message-charset=utf-8 -o tls=auto

fi

exit
                 