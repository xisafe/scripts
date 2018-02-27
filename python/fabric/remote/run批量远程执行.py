#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club

#Date:      18-2-27
#Description: fab  -f scrpit.py  do
# --------------------------------------------------
from fabric.api import env,run


hosts = []
file = open('host.txt','r')
for line in file.readlines():
    line = line.strip()
    if line:
        hosts.append(line)
file.close()
#主机列表信息


env.user = 'root'
env.password = input('输入密码：')
env.hosts=hosts
#远程帐号密码

def do():
        run("uptime")
#远程执行命令
