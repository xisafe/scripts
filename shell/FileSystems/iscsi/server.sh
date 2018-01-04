#服务端配置 (targetd)

yum install -y scsi-target-utils #安装服务端
service tgtd start && chkconfig tgtd on #启动服务
tgtadm --lld iscsi --op new --mode target --tid 1 --targetname iscsi.data
#创建逻辑单元1，磁盘iscsi.data
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /dev/sdb
#创建LUN1 物理设备/dev/sdb
tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL
#权限acl允许
tgtadm --lld iscsi --op show --mode target
#查看下iscsi盘状态