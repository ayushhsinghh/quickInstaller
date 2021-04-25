#!/usr/bin/bash


DISTRO=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
VERSION=$(cat /etc/*-release | grep VERSION | awk ' /VERSION_ID/ {print}' | cut -d = -f2 | tr -d  '"')
echo "Determined platform: $DISTRO $VERSION"

if [[ $DISTRO == 'Red Hat Enterprise Linux' ]]
then 
  if sudo rpm -q docker-ce &> /dev/null 
    then
    echo "Docker Is Alrealy Installed!"
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
                    echo "Docker Installed Successfully and Started !"
                fi
            else
                echo "Docker Not Installed. Contact Administrator"
            fi
        else
            echo "This Script Only Works For RHEL 7 and 8. Contact Administrator"
        fi
        fi
fi


