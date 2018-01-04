#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2017-12-29 00:50:41
#Description:	nmb
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
	chkconfig nmb on  || systemctl enable nmb
}

Set_nmb()
{
	sed -i "/\[global/a\netbios name = samba" /etc/samba/smb.conf
	service nmb restart

}

Install_samba