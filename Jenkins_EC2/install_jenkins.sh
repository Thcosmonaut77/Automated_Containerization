#!/bin/bash
set -e

echo "===== Updating system packages ====="
sudo apt-get update -y
sudo apt-get upgrade -y

echo "===== Installing java ====="
sudo apt-get install -y openjdk-21-jdk

echo "===== Adding Jenkins repository and GPG key ====="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "===== Updating package list and installing Jenkins ====="
sudo apt-get update -y
sudo apt-get install -y jenkins

echo "===== Installing Maven build tool ====="
sudo apt-get install -y maven

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-key fingerprint 0EBFCD88
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker ubuntu
sudo usermod -aG docker $USER 
sudo usermod -aG docker jenkins

echo "===== Enabling and starting Jenkins ====="
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "===== Jenkins installation complete ====="
echo "Initial Jenkins admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword