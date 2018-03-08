#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club

#Date:      18-3-6
#Description:
# --------------------------------------------------



import time, sys, os, re
import paramiko




host = '122.225.68.107'
user = 'admin'
passwd = 'ming0520!'


def sshclient(host, passwd, cmdlist):
    paramiko.util.log_to_file('paramiko.log')
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=host,
                username=user,
                password=passwd,
                port=55555,
                pkey=None,look_for_keys=False,
                allow_agent=False)
    remote_conn = ssh.invoke_shell()
    #进入交互式的shell

    time.sleep(0.5)  # 设置间隔
    remote_conn.recv(1000)

    for cmd in cmdlist:

        remote_conn.send(cmd) #发送命令

        time.sleep(1)
        info=remote_conn.recv(1000).decode()
        location=re.findall(r"(.*\]).*",info)[0]
        print(" %s\033[31m%s\033[0m" % (location,cmd.strip()))


        if info.find('written')>-1:
            remote_conn.send("Y\n")
            time.sleep(1)
            #print(remote_conn.recv(1000))
            remote_conn.send("\n")
            #print(remote_conn.recv(1000))
            remote_conn.send("Y\n")
            time.sleep(5)
            print(remote_conn.recv(1000))

    ssh.close()





if __name__ == "__main__":

    num = int(input("切换默认路由：\n1.BGP线路\n2.电信线路\n\n"))
    if num == 1 :
        cmdlist = open("run1.txt")
        sshclient(host, passwd, cmdlist)
        #执行脚本

    elif num == 2:
        cmdlist = open("run2.txt")
        sshclient(host, passwd, cmdlist)
        #恢复脚本

    else:
        print("\n错误的选项!!!")
        sys.exit(0)
        # 打印路由表

    cmdlist.close()

