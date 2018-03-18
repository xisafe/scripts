#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------
#Author:  LJ
#Email:   admin@attacker.club

#Last Modified: 2018-03-15 18:31:10
#Description: 
# --------------------------------------


import re





HostFile = open('hosts.txt')

for i in HostFile:
    if re.match(r'(\w+)-(\d+-\d+)',i):
        r = re.match(r'(\w+)-(\d+-\d+)',i).groups()
        host = i.strip() #主机名 
        hostdomain = r[1] + "." + r[0] #域名
        print (hostdomain) #打印主机名和ip地址
        with open('hostname.txt','a') as f:
            f.write(hostdomain+'\n')
            f.flush()
            f.close()


HostFile.close()


 

       
