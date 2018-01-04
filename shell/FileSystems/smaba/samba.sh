#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-12-29 00:48:33
#Description:	
# --------------------------------------------------


function color_message()
{ 
  case "$1" in
      "warn")
      echo -e "\e[1;31m$2\e[0m"
      ;;
      "info")
      echo -e "\e[1;33m$2\e[0m"
      ;;
  esac
}


Install_samba()
{
	yum install samba -y
	chkconfig smb on  || systemctl enable smb
}


Set_smb()
{
	sed -i "/\[global/a\guest account = nobody" /etc/samba/smb.conf
	sed -i "/\[global/a\map to guest = bad user" /etc/samba/smb.conf


	groupadd -g 510 smbadmin || groupadd smbadmin
	useradd  -u 510 -M -s /sbin/nologin -g smbadmin  smbadmin || useradd   -M -s /sbin/nologin -g smbadmin  smbadmin
	mkdir -p /data/smb  &&  chown smbadmin:smbadmin /data/smb
	mkdir -p /data/public 

	useradd   -M -s /sbin/nologin  readsmb
	color_message "info" "smbadmin add passwd" 
	smbpasswd -a smbadmin
	color_message "info" "readsmb add passwd" 
	smbpasswd -a readsmb



cat > /etc/samba/smb.conf <<EOF
[global]
workgroup = WORKGROUP
server string = Samba Server 
security = user
passdb backend = tdbsam
printing = cups
printcap name = cups
load printers = yes
cups options = raw
map to guest = bad user
guest account = nobody

[public]
comment = Anonymous share
path = /data/public
browseable = yes
guest ok = yes
read only = yes
[data]
comment = DataLib
path = /data/smb
valid users = @smbadmin smbadmin readsmb
#有效的用户和组
read list = readsmb
#只读用户和组
write list = smbadmin
#读写用户和组
EOF
service smb restart
}

Install_samba
Set_smb
#http://blog.attacker.club/Service/samba.html