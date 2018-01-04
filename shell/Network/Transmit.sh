#!/bin/bash
source /root/.bash_profile
HOST=192.168.21.103
SSH_SERVER="ecp@134.96.138.125 -p 24242"
declare -a T
declare -a D

T[0]="-L $HOST:33900:192.168.102.90:3389"
T[1]="-L $HOST:33910:192.168.102.93:3389"



function start()
{
pidwl=$(ps -ef|grep -v grep|grep "$SSH_SERVER"|wc -l)
if [ "X$pidwl" == "X0" ]; then
    nohup /usr/local/bin/sshpass -p 'password' ssh -o ServerAliveInterval=6 -2 -f -nNT ${T[*]} $SSH_SERVER &
    echo "start $SSH_SERVER"
fi

echo `date +%Y%m%d%H%M%S`
}

function stop()
{
    ps -ef|grep -v grep|egrep "ServerAliveInterval"|awk '{print $2}'|xargs kill -9
    echo "stop Transmit"
}


case "$1" in
    start)
    $1
    ;;
    stop)
    $1
    ;;
    restart)
    stop
    start
    ;;
esac

