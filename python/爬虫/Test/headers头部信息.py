#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:		LGhost
#Site:		    blog.attacker.club
#Email:			admin@attacker.club

#Last Modified time: 2017-12-27 23:44:10
#Description:   
# --------------------------------------------------
import requests
import time

#导入模块

'blog.attacker.club'

headers = { "Accept":"text/html,application/xhtml+xml,application/xml;",
            "Accept-Encoding":"gzip",
            "Accept-Language":"zh-CN,zh;q=0.8",
            "Referer":"http://blog.attacker.club/",
            "User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36"
            }



url = 'http://blog.attacker.club/Linux/shell-13.html'

html = requests.get(url,headers=headers)
content = html.text
print (content)
time.sleep(3)