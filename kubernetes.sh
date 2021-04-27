#!/usr/bin/bash
Red='\033[0;31m'    # Red Color
Green='\033[0;32m'  # Green Color
Color_Off='\033[0m' # Reset Color

DISTRO=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
VERSION=$(cat /etc/*-release | grep VERSION | awk ' /VERSION_ID/ {print}' | cut -d = -f2 | tr -d  '"')
echo "Determined platform: $DISTRO $VERSION"

if [[ $DISTRO == 'Red Hat Enterprise Linux' ]]
then 
    if sudo rpm -q kubectl &> /dev/null 
    then
    echo -e "${Green}Kubectl is Installed Already${Color_Off}"
    else
    sudo cp kubernetes.repo /etc/yum.repos.d/kubernetes.repo
    sudo yum update -y
    sudo yum install -y kubectl
    sudo apt install conntrack -y
    fi
    sudo rpm -q docker-ce > /dev/null 2>&1
    if [ "$?" -ne "0" ];
    then
    echo -e "${Green}Installing Docker${Color_Off}"
    source docker.sh
    fi
    sudo rpm -q minikube > /dev/null 2>&1
    if [ "$?" -ne "0" ];
    then
    lscpu | grep x86_64
        if [ "$?" -eq "0" ];
        then
        echo -e "${Green}Installing MiniKube${Color_Off}"
        sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
        sudo rpm -ivh minikube-latest.x86_64.rpm
        else
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.aarch64.rpm
        sudo rpm -ivh minikube-latest.aarch64.rpm
        fi
    fi
    if  rpm -q minikube > /dev/null 2>&1
    then 
        echo -e "${Green}MiniKuber Installed SuccessFully${Color_Off}"
    else
       echo -e "${Red} MiniKube Not Installed. Contact Administrator${Color_Off}"
    fi
    
fi

