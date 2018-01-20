#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: richard
# @Date:   2017-08-17 16:40:03
# @Last Modified by:   richard
# @Last Modified time: 2017-08-17 17:50:49

import commands
DEBUG=""
CMD="redis-cli -c -p 7000 cluster nodes"
def merge(master,slave):
    for each_m in master:
        print "Master: {ip_port},{state},{slot},{id}".format(**each_m)

        for each_s in slave:
            if each_s['master_id'] == each_m['id']:
                print "\tSlave: {ip_port},{state},{id}".format(**each_s)

def parse_content(content):
    master_list,slave_list,fail_list=[],[],[]
    for each in content:
        # print each
        if each.find("master") > -1 and each.find("fail") < 0 :
            master={}
            try:
                split_value = each.split()
                master['id'] = split_value[0]
                master['ip_port'] = split_value[1]
                master['state'] = split_value[-2]      
                master['slot'] = split_value[-1]      
            except IndexError,e:
                print e         
            else:
                master_list.append(master)

        if each.find("slave") > -1 and each.find("fail") < 0:
            slave={}
            try:
                split_value = each.split()
                slave['id'] = split_value[0]
                slave['ip_port'] = split_value[1]
                slave['master_id'] = split_value[3]
                slave['state'] = split_value[-1]
            except IndexError,e:
                print e
            else:
                slave_list.append(slave)

        if each.find("fail") > -1:
            print "Fail",each
    merge(master_list,slave_list)

if __name__ == '__main__':
    if DEBUG:
        f = open('/tmp/1','r')
        GET_INFO=f.readlines()
        parse_content(GET_INFO)
    else:
        cmd = commands.getstatusoutput(CMD)
        if cmd[0] == 0:
            GET_INFO=cmd[1].split('\n')
            parse_content(GET_INFO)
        else:
            print "run error"



