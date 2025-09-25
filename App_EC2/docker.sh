#/bin/bash
set -e

 # Update system packages
      sudo apt-get update -y
      sudo apt-get upgrade -y

      # Install Docker
      sudo apt-get install -y docker.io

      # Start and enable Docker service
      sudo systemctl enable docker
      sudo systemctl start docker

      # Add ubuntu user to docker group
      sudo usermod -aG docker ubuntu

      # Verify Docker installation
      docker --version || echo Docker installed!