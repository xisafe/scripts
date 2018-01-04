#权限

tgtadm --lld iscsi --op new --mode account --user admin --password 123456 #创建用户
tgtadm --lld iscsi --op show --mode account #查看
tgtadm --lld iscsi --op bind --mode account --tid 1 --user admin #指定账户到iscsi盘 
tgtadm --lld iscsi --op show --mode target  #查看