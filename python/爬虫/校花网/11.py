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
url = 'http://wwww.xiaohuar.com/hua'
response = requests.get(url)
html = response.text
img_url = re.findall(r'/d/file/\d/\w+\.jpg',html)

for img_url in img_urls:
    img_response = requests.get('http://www.xiaohuar.com%s'% img_url)


    img_data = img_response.content
    beauty = img_url.split('/')[-1]
    with open(beauty,'wd')as f:
        f.write(img_data)
        f.close()
