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

import os,re,time
import requests




def get_html(url):  #请求页面
    response = requests.get(url,headers=headers)
    response.encoding = 'gbk'
    html = response.text
    return html




def get_novel_list (url): #小说列表
    html = get_html(url)
    req = r'<a href="(.*?)">'
    result = re.findall(req,html)
    return result


#def get_chapter_list():






    #print(novel_list)
    #req = r '<a target="_blank" title="(.*?)'"herf" =

if __name__ == "__main__":

    headers = { "Accept":"text/html,application/xhtml+xml,application/xml;",
                "Accept-Encoding":"gzip",
                "Accept-Language":"zh-CN,zh;q=0.8",
                "Referer":"http://www.quanshuwang.com/",
                "User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36"
                }


    for page_num in range(1,2):
        url = 'http://www.quanshuwang.com/all/allvisit_1_0_0_0_1_0_%s.html' % page_num
        #完结玄幻小说
        print(get_novel_list(url))


    #html = get_sort_list()



    """
    for sort_url,sort_name in html:
        if (sort_name == '玄幻魔法' or sort_name == '武侠修真') :
            print(sort_url,sort_name)

            path = os.path.join (sort_name)
            if not os.path.exists(path):
                os.mkdir(path) #建目录
                print(sort_url)
            else:
                print('%s 目录已存在~' % (sort_name))
                continue

            novel_html = get_novel_list (sort_url)
            print(novel_html)
    
    """

            #for novel_url,novel_name in novel_html:
