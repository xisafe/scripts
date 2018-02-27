#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club

#Date:      18-2-27
#Description:
# --------------------------------------------------

from fabric.api import env,put,get,prompt


'''
hosts = []
file = open('host.txt','r')
for line in file.readlines():
    line = line.strip()
    if line:
        hosts.append(line)
file.close()
#主机列表信息
'''
env.hosts= ['10.0.0.223']
env.user = 'root'



@runs_once
def input_raw():
    return prompt("请输入密码",default="123456")
#远程帐号密码

@task
def upload():
    env.password = input_raw()
    put("/data//host.txt","/home/")
    #上传文件：本地目录,远程目录

@task
def download():
    env.password = input_raw()
    get("/home/*","/home/logos/hehe")
    #下载文件： 远程目录,本地目录
