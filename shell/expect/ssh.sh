#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:		admin@attacker.club


#Last Modified: 2018-02-24 18:03:40
#Description:	
# --------------------------------------------------

#!/bin/bash 
passwd='password'
#定义密码

/usr/bin/expect <<EOF 
set time 30 
spawn ssh root@192.168.1.220 
expect { "*yes/no" { send "yes\r"; exp_continue 
} "*password:" { send "$passwd\r" } 
} 
expect "*#" 
send "/root/auto.sh\r" 
exec sleep 3
send "exit\r" 
expect eof 
EOF 

