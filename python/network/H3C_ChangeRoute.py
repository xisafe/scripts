#!/usr/bin/env python
# -*- coding:UTF-8 -*-
# Author Lj
# Mail:admin@attacker.club
# blog:blog.attacker.club
# description SSH change route
import time, sys, os, re
import paramiko
import logging
import logging.handlers

# import pickle   #存用户名密码
FW_ADDR = "192.168.120.1"
FW_PASSWD = input('输入密码')


OUT_ADDR = {
    'bgp': '43.225.180.225',
    'dx':  '115.236.46.161'
}


def warn (Text):
    print (">>>>>\t\t\033[1;31m%s\033[0m\t<<<<<" % Text)
def info (Text):
    print (">>>>>\t\t\033[1;33m%s\033[0m\t<<<<<" % Text)
#提示

def sshclient(host, passwd, cmd):
    paramiko.util.log_to_file('paramiko.log')
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=host, port=55556, username='admin', password=passwd, pkey=None, look_for_keys=False,
                allow_agent=False)
    remote_conn = ssh.invoke_shell()
    time.sleep(0.5)  #
    remote_conn.recv(10000)
    remote_conn.send("sys\n")
    time.sleep(0.5)
    remote_conn.send(cmd)
    time.sleep(1)
    print(remote_conn.recv(10000))
    ssh.close()


if __name__ == "__main__":
    #passwd = raw_input("请输入密码:")
    num = input("1.BGP线路\n2.电信线路\n其他任意键打印路由表:\t")


    if num == '1' :
        DO = "ip route-static 0.0.0.0 0 %s\n" % (OUT_ADDR['bgp'])
        UNDO = "undo ip route-static 0.0.0.0 0 %s\n" % (OUT_ADDR['dx'])
        ROUTE = DO + UNDO
        warn  ('当前出口切换至BGP')

    elif num == '2' :
        DO = "ip route-static 0.0.0.0 0 %s\n" % (OUT_ADDR['dx'])
        UNDO = "undo ip route-static 0.0.0.0 0 %s\n" % (OUT_ADDR['bgp'])
        ROUTE = DO + UNDO
        warn  ('当前出口切换至电信')

    else:
        warn  ("打印路由表")
        display = 'dis cur  | i route-static\n'
        sshclient(FW_ADDR,FW_PASSWD,display)
        sys.exit(0)

    sshclient(FW_ADDR,FW_PASSWD,ROUTE)
    info('执行结束')



