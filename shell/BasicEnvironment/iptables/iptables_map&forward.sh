#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-12-15 19:05:11
#Description:	
# --------------------------------------------------


iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080 
#通过80访问Tomcat主机的8080

