#!/bin/bash
Email=./sendEmail.perl

smtp=smtp.attacker.club
#发件人SMTP服务器
user=info@attacker.club
#发件人账号
passwd='*******'
#发件人密码
to=888888@qq.com
#收件人邮件地址
subject='主题'
body="测试邮件内容"

$Email  -f $user -s $smtp -xu $user -xp $passwd -t $to -u $subject -m $body

#-o message-content-type=html   邮件内容的格式,html表示它是html格式
#-o message-charset=utf8        邮件内容编码
