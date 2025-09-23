#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Ensure cloud-init has finished network setup
sleep 30

echo "===== Installing Terraform ====="
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Run update twice to ensure repo is active
sudo apt-get update -y || true
sudo apt-get update -y

sudo apt-get install -y terraform

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

echo "===== Installing Docker ====="
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker ubuntu
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins



echo "===== Enabling and starting Jenkins ====="
sudo systemctl enable jenkins
sudo systemctl start jenkins



echo "===== Jenkins installation complete ====="
echo "Initial Jenkins admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword