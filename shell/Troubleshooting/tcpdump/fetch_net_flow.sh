#!/bin/bash
# @Author: richard
# @Date:   2017-05-12 17:48:37
# @Last Modified by:   richard
# @Last Modified time: 2017-05-15 17:13:01
# 抓取一段时间的网卡包

# set fetch second
fetch_time=3

#set network deivce
# enp0s31f6
net_dev=em1

declare -a IP

IP=(115.231.231.41 101.68.218.94 223.95.183.139 10.0.4.106)

function do_dump()
{
	    local dest=$1
	        name=$(echo $dest|tr '.' '_' )".cab"
		    tcpdump -i $net_dev -s1514 dst $dest -w $name &
	    }

	    for i in ${IP[*]}
	    do
	    do_dump $i
	                
    done



    function get_pid()
    {
	    echo `ps -ef|grep tcpdump|grep -v grep|awk '{print $2}'`
    }

    future=$((`date +"%s"` + $fetch_time))

    while true
    do
	    if [ `date +"%s"` -eq "$future" ];then
		        for i in $(get_pid)
				    do
					        /bin/kill -9 $i
						    exit 0;
					    done
				    fi

			    done







