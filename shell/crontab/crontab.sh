#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:03:41
#Description:	
# --------------------------------------------------

#查看计划任务列表
crontab -e
#进入编辑计划任务模式
grep 'SSH' /var/spool/cron/root &>/dev/null  ||echo  '*/5 * * * *  sh /root/SSH_Deny_Rule.sh' >>  /var/spool/cron/root
#没有添加任务时追加一个


#more: http://blog.attacker.club/Service/crontab_at.html