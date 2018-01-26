#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:		LJ
#Email: admin@attacker.club
#Site:  blog.attacker.club
#Mail:  admin@attacker.club
#Date:  2017/9/16
#Description:   
# --------------------------------------------------

#!/usr/bin/python
# -*- coding: UTF-8 -*-

import smtplib
from email.mime.text import MIMEText
from email.header import Header

# 第三方 SMTP 服务
mail_host="smtp.attacker.club"  #设置服务器
mail_user="info@attacker.club"  #用户名
mail_pass="ZXCVBNMP0-"           #密码

receivers = '2281121225@qq.com'  # 接收邮件

message = MIMEText('Python 邮件发送测试...', 'plain', 'utf-8')
message['From'] = mail_user
message['To'] =  receivers

subject = 'Python SMTP 邮件测试'
message['Subject'] = Header(subject, 'utf-8')


try:
    smtpObj = smtplib.SMTP()
    smtpObj.connect(mail_host, 25)    # 25 为 SMTP 端口号
    smtpObj.login(mail_user,mail_pass)
    smtpObj.sendmail(mail_user, receivers, message.as_string())
    print "邮件发送成功"
except smtplib.SMTPException:
    print "Error: 无法发送邮件"