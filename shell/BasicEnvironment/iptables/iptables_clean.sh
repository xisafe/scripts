#!/bin/bash

####---- 清空iptables策略 ----####
iptables -F
iptables -X
iptables -Z
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat



####---- INPUT链设置 ----####
iptables -P INPUT ACCEPT
#开放INPUT链
iptables-save
service iptables save
