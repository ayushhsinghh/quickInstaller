#!/usr/bin/bash
Red='\033[0;31m'    # Red Color
Green='\033[0;32m'  # Green Color
Blue='\033[0;34m'   # Blue Color
Color_Off='\033[0m' # Reset Color

DISTRO=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
VERSION=$(cat /etc/*-release | grep VERSION | awk ' /VERSION_ID/ {print}' | cut -d = -f2 | tr -d  '"')
echo -e "${Blue}Determined platform: $DISTRO $VERSION ${Color_Off}"

if [[ $DISTRO == 'Red Hat Enterprise Linux' ]]
then 
  if sudo rpm -q docker-ce &> /dev/null 
    then
    echo -e "${Green}Docker Is Alrealy Installed!${Color_Off}"
    else
        if sudo cat /etc/*-release | grep Ootpa &> /dev/null
        then
            sudo cp dockerRhel.repo /etc/yum.repos.d/dockerce.repo
            sudo yum update -y
            sudo yum install docker-ce --nobest  -y
            if sudo rpm -q docker-ce &> /dev/null
            then 
                sudo systemctl start docker
                if sudo systemctl status docker | grep active &> /dev/null
                then
                    echo "Docker Installed Successfully and Started !"
                fi
            else
                echo "Docker Not Installed. Contact Administrator"
            fi
        elif sudo cat /etc/*-release | grep Maipo  &> /dev/null
        then
            sudo cp dockerRhel.repo /etc/yum.repos.d/dockerce.repo
            sudo yum update -y
            sudo yum install http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm -y
            sudo yum install device-mapper-persistent-data lvm2 docker-ce -y
            if sudo rpm -q docker-ce &> /dev/null
            then 
                sudo systemctl start docker
                if sudo systemctl status docker | grep active &> /dev/null
                then
                    echo -e "${Green}Docker Installed Successfully and Started ! ${Color_Off}"
                fi
            else
                echo -e "${Red}Docker Not Installed. Contact Administrator${Color_Off}"
            fi
        else
            echo -e "${Red}This Script Only Works For RHEL 7 and 8. Contact Administrator ${Color_Off}"
        fi
        fi
fi


