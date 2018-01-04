#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:		LGhost
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
        ipadd = Domain_ip(hostdomain) #dns解析地址
        #print (type(ipadd)) #dns返回的数据类型
        #print (host,ipadd) #打印主机名和ip地址
        print (hostdomain)
        if ipadd is not None:
            file ('hostname.txt','a',host +'\t'+ hostdomain +'\t' + ipadd +'\n')
            #主机列表写入文件
        #else:
        #    file ('error.txt','a',host +'\t'+ ipadd  +'\n')
            #解析失败的写入文件
