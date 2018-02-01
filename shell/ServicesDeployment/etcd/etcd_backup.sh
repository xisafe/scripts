#!/bin/bash
date_time=`date +%Y%m%d`
etcdctl backup  --data-dir  /data/etcd/defualt  --backup-dir    /data/etcd_backup/${date_time}

find /data/etcd_backup/ -ctime +6 -exec rm -r {} \;