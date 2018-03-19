#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email:     admin@attacker.club

#Date:      18-3-18
#Description:
# --------------------------------------------------



#   python  diff-db.py

import os,sys,pymysql,re



f = open('/usr/local/zabbix-agent/etc/zabbix_agentd.conf')
for i in f:
	if i.find('Hostname')>-1:
		prod=re.findall(r'.*\=(\w+)\-*',i)[0]
f.close()
#Hostname=live-access


def con_jp(cmd):
    db = pymysql.connect("10.1.1.1", "jumpserver", "xxxxxx", "jumpserver")
    cursor = db.cursor()
    cursor.execute(cmd)
    data = cursor.fetchall()
    db.close()
    return data

def con_zbx(cmd):
    db = pymysql.connect(host='115.1.1.1', port=6033, user='zabbix', passwd='xxxxxx', db='zabbix', charset='utf8')
    cursor = db.cursor()
    cursor.execute(cmd)
    data = cursor.fetchall()
    db.close()
    return data



class jumpserver(object):
    def __init__(self):
        self.host=con_jp("SELECT ip FROM jasset_asset")
        self.count=con_jp("SELECT count(ip) FROM jasset_asset")


class zabbix(object):
    def __init__(self,project):
        self.host= con_zbx("SELECT DISTINCT(listen_ip) FROM autoreg_host,`hosts` WHERE autoreg_host.`host` = `hosts`.`host`  AND  `hosts`.`host`  LIKE  '%%%s%%' " % project)
        self.count=con_zbx("SELECT  COUNT(DISTINCT(listen_ip)) FROM autoreg_host,`hosts` WHERE autoreg_host.`host` = `hosts`.`host`  AND  `hosts`.`host`  LIKE  '%%%s%%' " % project)






if __name__ == "__main__":

    jp = jumpserver()
    zbx = zabbix(prod)
    jpCount=jp.count[0][0]
    zbxCount=zbx.count[0][0]
    num=(set(jp.host)-set(zbx.host))
    #print("jumpserver:",jpCount,"zabbix:",zbxCount)
    #print(num) #查看未匹配的主机

    print (len(num))




