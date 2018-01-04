#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:		LJ
#Email: admin@attacker.club
#Site:  blog.attacker.club
#Mail:  admin@attacker.club
#Date:  2017/12/28
#Description:   
# --------------------------------------------------

import requests
import re
import time


headers = { "Accept":"text/html,application/xhtml+xml,application/xml;",
            "Accept-Encoding":"gzip",
            "Accept-Language":"zh-CN,zh;q=0.8",
            "Referer":"http://xiaohuar.com/",
            "User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36"
            }

url =  'http://xiaohuar.com/hua'
response = requests.get(url,headers=headers)
html = response.text



#/d/file/20170824/dcc166b0eba6a37e05424cfc29023121.jpg
img_urls = re.findall(r'/d/file/\d+/\w+\.jpg',html)

time.sleep(1.5)

for img_url in img_urls:
    #img_response = requests.get(url+img_url)
    img_response = requests.get('http://xiaohuar.com%s' % img_url)
    print(img_response)
    img_data = img_response.content #二进制信息
    beauty = img_url.split('/')[-1] #去最后一个值

    with open(beauty,'wb') as f:
        f.write(img_data)
        f.close()




#with open('')
