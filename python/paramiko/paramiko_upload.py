#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email: admin@attacker.club

#Date:  2017/12/28
#Description:
# --------------------------------------------------

import paramiko
import os
import datetime


hostname = '10.0.0.223'
username = 'root'
password = 'huored'
port = 22
local_dir = '/data/items/test'
remote_dir = '/data'
if __name__ == "__main__":
    #    try:
    t = paramiko.Transport((hostname, port))
    t.connect(username=username, password=password)
    sftp = paramiko.SFTPClient.from_transport(t)
    #        files=sftp.listdir(dir_path)
    files = os.listdir(local_dir)
    for f in files:
        '#########################################'
        'Beginning to upload file %s ' % datetime.datetime.now()
        'Uploading file:', os.path.join(local_dir, f)
        # sftp.get(os.path.join(dir_path,f),os.path.join(local_path,f))
        sftp.put(os.path.join(local_dir, f), os.path.join(remote_dir, f))
        'Upload file success %s ' % datetime.datetime.now()
    t.close()
