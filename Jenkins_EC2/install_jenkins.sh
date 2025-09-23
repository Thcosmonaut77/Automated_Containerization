#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Ensure cloud-init finishes networking
sleep 30

echo "===== Updating system packages ====="
sudo apt-get update -y
sudo apt-get upgrade -y

# -------------------------------------------------------------------
# 1. Install prerequisites
# -------------------------------------------------------------------
echo "===== Installing base dependencies ====="
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common wget

# -------------------------------------------------------------------
# 2. Install Terraform
# -------------------------------------------------------------------
echo "===== Installing Terraform ====="
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y terraform

# -------------------------------------------------------------------
# 3. Install Docker (before Jenkins)
# -------------------------------------------------------------------
echo "===== Installing Docker ====="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add users to docker group
sudo usermod -aG docker ubuntu
sudo usermod -aG docker $USER

# -------------------------------------------------------------------
# 4. Install Java (needed before Jenkins)
# -------------------------------------------------------------------
echo "===== Installing Java ====="
sudo apt-get install -y openjdk-21-jdk

# -------------------------------------------------------------------
# 5. Install Jenkins
# -------------------------------------------------------------------
echo "===== Adding Jenkins repository and GPG key ====="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# Add Jenkins user to Docker group
sudo usermod -aG docker jenkins

# Restart Jenkins so new group applies
sudo systemctl daemon-reexec
sudo systemctl restart jenkins

# -------------------------------------------------------------------
# 6. Install Maven
# -------------------------------------------------------------------
echo "===== Installing Maven ====="
sudo apt-get install -y maven

# -------------------------------------------------------------------
# 7. Start and enable Jenkins
# -------------------------------------------------------------------
echo "===== Enabling Jenkins ====="
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -------------------------------------------------------------------
# 8. Output Jenkins initial password
# -------------------------------------------------------------------
echo "===== Jenkins installation complete ====="
echo "Initial Jenkins admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
