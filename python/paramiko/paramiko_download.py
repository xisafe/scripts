#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email: admin@attacker.club

#Date:  2017/12/28
#Description:
# --------------------------------------------------

import paramiko
import os,sys
import datetime





def ProgressBar(transferred, toBeTransferred,suffix=''):
    bar_len = 60
    filled_len = int(round(bar_len * transferred/float(toBeTransferred)))
    percents = round(100.0 * transferred/float(toBeTransferred), 1)
    bar = '=' * filled_len + '-' * (bar_len - filled_len)
    sys.stdout.write(' [%s]%s%s ...%s\r' % (bar,percents,'%',suffix))
    sys.stdout.flush()




def Doownload():


    remote_file = '/home/1G'
    local_file = '/data/1G'

    t = paramiko.Transport((hostname, port))
    t.connect(username=username, password=password)

    sftp = paramiko.SFTPClient.from_transport(t)
    sftp.get(remote_file,local_file,callback=ProgressBar)
    t.close()

    print("\n"  "%s\t下载成功" % remote_file)





if __name__ == "__main__":

    port = 22
    username = 'root'
    password = input('输入密码：')

    hostname = '10.0.0.223'
    Doownload()
    sys.exit(0)


'''
    file = open('host.txt', 'r')
    hosts = []
    for line in file.readlines():
        line = line.strip()
        if line:
            hosts.append(line)
            hostname = line
            Doownload()
            # 批量主机
'''






