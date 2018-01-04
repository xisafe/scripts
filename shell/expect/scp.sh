#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-12-15 23:06:24
#Description:	
# --------------------------------------------------



#!/bin/bash
passwd='123456'
#定义密码

/usr/bin/expect <<-EOF
set time 300
spawn  scp -P 2201  /home/go/z/goapp.tar.gz  root@10.139.1.1:/data
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "$passwd\r" }
}
expect eof
EOF

