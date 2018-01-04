**硬件资源查询**
----
1.SN号

    dmidecode | grep -i serial|awk NR==2

2.硬盘

    fdisk -l |sed s/,// |cut -d " " -f 2-4 |grep dev
    #查看硬盘大小
    blkid
    #查看硬盘UUID
    

3.内存

    cat /proc/meminfo |awk  'NR==1'|awk '{print $2}'
    #查看内存或使用free -m

4.cpu

    cat /proc/cpuinfo| grep "cpu cores"| uniq
    #查看每个物理CPU中core的个数(即核数)
    cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
    #查看物理CPU个数
    grep "model name" /proc/cpuinfo |awk -F ':' '{print $NF}'|uniq
    #查看CPU信息（型号）


<!--more-->

5.网卡 

    nmcli -c
    #查看网卡UUID
    ip add ; ifconfig
    #查看ip和mac地址 两种方法都可以
    
    ethtool eno16777736 |egrep 'Speed|Duplex'
    #查看eno16777736网卡(物理机) 速度和双工模式
    watch 'ethtool -S eno16777736 |grep packets'
    #查看eno16777736网卡 RX下行流量，TX上行流量 
    ethtool -h //显示ethtool的命令帮助(help)
    ethtool eno16777736    //查询ethX网口基本设置
    ethtool -i eno16777736 //查询ethX网口的相关信息
    ethtool -d eno16777736 //查询ethX网口注册性信息


6.资源

    curl -s http://list.attacker.club/1.scripts/1.Shell/hardware/hwconfig.perl |bash
    #查看服务器信息
    