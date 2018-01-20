#/bin/bash

starttime=`date +'%Y-%m-%d %H:%M:%S'`
cat iptables.init > iptables_init_rule.sh

echo '#放行国内ip访问80'  >> iptables_init_rule.sh

wget http://www.ipdeny.com/ipblocks/data/countries/cn.zone 2>/dev/null
#调出ip段，导入到iptables配置文件中
for i in `cat cn.zone`
do
echo "iptables -A INPUT -s $i -p tcp -m multiport --dports  80,443 -j ACCEPT" >> iptables_init_rule.sh
done

bash iptables_init_rule.sh
#保存iptable配置到本地
iptables-save
service iptables save
#清除临时文件
rm iptables_init_rule.sh -f
rm cn.zone* -f 
endtime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
echo "本次运行时间： "$((end_seconds-start_seconds))"s"
