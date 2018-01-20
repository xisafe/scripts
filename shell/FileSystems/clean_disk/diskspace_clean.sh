#!/bin/bash
# --------------------------------------------------
#Author:	LGhost
#Email:		admin@attacker.club
#Site:		blog.attacker.club

#Last Modified: 2018-01-18 17:43:41
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





clean_file ()
{
	find /home/bt/bbdata/2018 -name  "*.dat" -mtime +3 -type f -print   -exec rm -f {}\ ;
	color_message  "info" "删除旧文件"
}

clean_file