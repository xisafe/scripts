#!/bin/bash
# --------------------------------------------------
#Author:    LJ
#Email:			admin@attacker.club
#Site:		    blog.attacker.club

#Last Modified time: 2017-11-22 18:19:12
#Description:	
# --------------------------------------------------


function color()
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




function confirm()
{
  read -p 'Are you sure to Continue?[Y/n]:' answer
  case $answer in
  Y | y)
        echo -e "\n\t\t\e[44;37m Running the script \e[0m\n";;
  N | n)
        echo -e "\n\t\t\033[41;36mExit the script \e[0m\n"  && exit 0;;
  *)
        echo -e "\n\t\t\033[41;36mError choice \e[0m\n"  && exit 1;;
  esac
}



function Cleanup()
{
	rm xxxx

}



confirm
Cleanup
