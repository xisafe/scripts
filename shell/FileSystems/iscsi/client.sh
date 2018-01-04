## Linux 客户的配置 (initiator)

yum install -y  iscsi-initiator-utils  scsi-target-utils #安装客户端组件
iscsiadm --mode discovery --type sendtargets --portal  192.168.0.104  #输入iscsi服务器ip
iscsiadm -m node -T iscsi.data  192.168.0.104  --login #登录iscsi
fdisk -l #查看硬盘