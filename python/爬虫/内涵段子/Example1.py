#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:		LJ
#Email: admin@attacker.club
#Site:  blog.attacker.club
#Mail:  admin@attacker.club
#Date:  2017/12/27
#Description:   内涵段子
# --------------------------------------------------

import requests
import time
#导入模块


headers = { "Accept":"text/html,application/xhtml+xml,application/xml;",
            "Accept-Encoding":"gzip",
            "Accept-Language":"zh-CN,zh;q=0.8",
            "Referer":"http://www.example.com/",
            "User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36"
            }



timestamp = 1
while type(timestamp) == int or type(timestamp) ==float:



    url= 'http://neihanshequ.com/joke/?is_json=1&app_name=neihanshequ_web&max_time='+str(timestamp)
    #请求地址
    html = requests.get(url,headers=headers)
    #内容
    #html.encoding = 'utf-8'

    timestamp = html.json()['data']['max_time']

    for i in range (20):
        content = html.json()['data']['data'][i]['group']['text']
        print(content)
        with open('heiheihei.TXT','a',encoding='utf-8') as f:
            f.write(content +'\n'*2,)
            f.close()

    time.sleep(3)



    print(timestamp)
    #通过时间戳翻页

