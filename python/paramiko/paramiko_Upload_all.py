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



def Upload_all():

    local_dir = '/data/items/test'
    remote_dir = '/data'
    t = paramiko.Transport((hostname, port))
    t.connect(username=username, password=password)

    sftp = paramiko.SFTPClient.from_transport(t)
    files = os.listdir(local_dir)
    for file in files:
        sftp.put(os.path.join(local_dir, file),
                 os.path.join(remote_dir, file),
                 callback=ProgressBar)
        print("\n"  "%s\t已上传" % file)
    t.close()





if __name__ == "__main__":

    hostname = '10.0.0.223'
    username = 'root'
    password = input('输入密码：')
    port = 22


    Upload_all()
    #将本地目录下的文件全部上传到目标主机
    sys.exit(0)




