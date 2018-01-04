#!/bin/bash
iptables -F
#清空所有链
iptables -t nat -F
#清空nat表所有链
iptables -X
iptables -t nat -X


####---- INPUT链设置 ----####
iptables -P INPUT ACCEPT
#开放INPUT链
iptables-save
service iptables save
