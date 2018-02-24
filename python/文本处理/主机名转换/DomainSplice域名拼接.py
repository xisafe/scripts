#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email: admin@attacker.club

#Mail:  admin@attacker.club
#Date:  2017/12/15
#Description:   
# --------------------------------------------------

import re

hostlist = []

def hosts():
    HostFile = open('hosts.txt')
    for i in HostFile:
        if re.match(r'(\w+)-(\d+-\d+)', i):
            r = re.match(r'(\w+)-(\d+-\d+)', i).groups()
            host = i.strip()  # 主机名
            hostdomain = r[1] + "." + r[0]  # 域名
            hostlist.append(hostdomain)
            #print (hostdomain) #打印主机名和ip地址




if __name__ == "__main__":
    hosts()

    file=open('hostname.txt','w')
    for line in hostlist:
        file.write(line+'\n')
    file.close()
