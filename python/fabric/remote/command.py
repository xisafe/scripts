#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club

#Date:      18-2-27
#Description:
# --------------------------------------------------

from fabric.api import *


def env.password = input('输入密码：')():
        run("ifconfig")


if __name__ == "__main__":
    env.user = 'root'
    env.password = input('输入密码：')
    file = open('host.txt','r')

    hosts = []
    for line in file.readlines():
        line = line.strip()
        if line:
            hosts.append(line)

    env.hosts=hosts


        #env.hosts.close()
