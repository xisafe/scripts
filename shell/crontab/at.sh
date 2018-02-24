#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:03:42
#Description:	at执行临时任务
# --------------------------------------------------

#

at now+10 minutes
#10分钟任务
at 5pm+3 days
#3天下午5点任务

at>命令行
at> ctrl +d (退出)

at -l
#查看列表
at -c 2
#查看详细任务
at -d 2
#删除条目2的计划任务