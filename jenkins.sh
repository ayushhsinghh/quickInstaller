#!/usr/bin/bash

DISTRO=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')
echo "Determined platform: $DISTRO"

if [[ $DISTRO == 'Red Hat Enterprise Linux' ]]
then
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum upgrade
    sudo yum install jenkins -y
    sudo dnf install java-1.8.0-openjdk -y
    sudo systemctl daemon-reload
    sudo systemctl start jenkins

    sudosystemctl restart firewalld
    YOURPORT=8080
    PERM="--permanent"
    SERV="$PERM --service=jenkins"
    firewall-cmd $PERM --new-service=jenkins
    firewall-cmd $SERV --set-short="Jenkins ports"
    firewall-cmd $SERV --set-description="Jenkins port exceptions"
    firewall-cmd $SERV --add-port=$YOURPORT/tcp
    firewall-cmd $PERM --add-service=jenkins
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --reload
else
echo "Sorry. This Script Will only Work On RedHat Linux"
fi

if systemctl status jenkins | grep active &> /dev/null
then
    echo "Jenkins Is Installed Successfully..."
    echo "Jenkins Is Running at localhost:${YOURPORT}"
    passwd=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
    echo "Your Intial Jenkins Password Is :  ${passwd}"
else
    echo "Jenkins Is Not Running Check Configation Again"
fi


