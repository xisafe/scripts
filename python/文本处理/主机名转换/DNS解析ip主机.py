#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Site:		    blog.attacker.club
#Email:			admin@attacker.club

#Last Modified time: 2017-12-29 11:06:10
#Description:   
# --------------------------------------------------

import re
import dns.resolver

#定义域名解析
def Domain_ip (domain):
    try:
        ip = dns.resolver.query(domain, 'A')
        for i in ip.response.answer:
            for j in i.items:
                return  j.to_text()

    except Exception as e:
        pass


def file(path,method,content):
    f=open(path,method)
    f.write(content)
    f.close()
#file



HostFile = open('hosts.txt')

for i in HostFile:
    if re.match(r'(\w+)-(\d+-\d+)',i):
        r = re.match(r'(\w+)-(\d+-\d+)',i).groups()
        host = i.strip() #主机名
        hostdomain = r[1] + "." + r[0] #域名
        ipaddr = Domain_ip(hostdomain) #dns解析地址
    
        print (ipaddr) #打印主机名和ip地址


        if ipaddr is not None:
            file ('hostname.txt','a',host +'\t' +'\t' + ipaddr +'\n')
            #写入文件
 