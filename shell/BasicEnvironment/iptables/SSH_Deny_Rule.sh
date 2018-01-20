#!/bin/bash
grep Failed /var/log/secure |egrep -o '[0-9]{1,3}(\.[0-9]{1,3}){3}' |sort |uniq -c|sort -nr | awk '{if($1 > 8) print $2}' > deny_ip

for i in `cat deny_ip`
do

echo "sshd:$i:deny" >> /etc/hosts.deny
done
