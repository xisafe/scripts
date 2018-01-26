#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
# Author:		LGhost
# Site:		    blog.attacker.club
# Email:			admin@attacker.club

# Last Modified time: 2017-12-14 15:59:27
# Description:
# --------------------------------------------------

import os



filelist = []
# 建空列表存文件路径


# 获取目录归档文件
def getfilelist(path):
    for dir, folder, files in os.walk(path):
        for file in files:
            #不包含脚本自身; 指定结尾扩展名file.endswith('sh')
            if script not in files :
                t = "%s\%s" % (dir, file)
                filelist.append(t)  #加入列表



# 替换密码文件
def replaced(file,passwd):
    try:
        #将文件读取到内存中
        with open(file,'r',encoding="utf-8") as f:
            lines = f.readlines()
        #写的方式打开文件
        with open(file,"w",encoding="utf-8") as f_w:
            for num,line in  enumerate(lines):
            #for line in lines:
                numline = lines.index(line)
                if passwd in line:
                    line = line.replace(passwd,'chpasswd')
                    print  (file,'\tchanged:',num+1)
                    #并列出行号
                f_w.write(line)
        f.close()
        f_w.close()
    except Exception as e:
        print  (e)
        





if __name__ == "__main__":
    passwd = input('输入要屏蔽的密码: ')
    script = os.path.basename(__file__)  # 获取脚本名称
    path = os.getcwd()  # 获取当前绝对路径

    getfilelist(path)
    for file in filelist:
        replaced(file,passwd)
        #print(file)
