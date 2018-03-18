#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Site:		    blog.attacker.club
#Email:			admin@attacker.club

#Last Modified time: 2017-12-27 12:18:40
#Description:   
# --------------------------------------------------

import re

hostlist = []

def hosts():
    HostFile = open('hosts.txt')
    for i in HostFile:
        if re.match(r'(\w+)-(\d+-\d+)', i):
            r = re.match(r'(\w+)-(\d+-\d+)', i).groups()
            host =  r[0] #主机
            hostname = i.strip()  # 主机名
          

            if host not in hostlist:
                hostlist.append(host)
                hostlist.sort()
                #1.不重复加入列表 2.排序





if __name__ == "__main__":
    hosts()

    file=open('hostname.txt','w')
    for line in hostlist:
        file.write(line+'\n')
    file.close()
