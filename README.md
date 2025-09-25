# Containerization_with_Docker
## Project Overview

This project demonstrates a complete CI/CD pipeline for deploying a Java web application on AWS.
It integrates Terraform, Jenkins, Docker, and Tomcat to provision infrastructure and automate deployments.

The pipeline builds the Java application from source, packages it into a WAR, containerizes it with Docker, and deploys it to an EC2 app server provisioned via Terraform.

## Repository Structure
```bash
.
├── App_EC2/                       # Application + Infrastructure for App Server
│   ├── src/main/webapp/            # Java webapp source (JSP + WEB-INF)
│   │   ├── index.jsp
│   │   └── WEB-INF/web.xml
│   ├── Dockerfile                  # Dockerfile packages the WAR into a Tomcat image (supports multi-stage builds if extended)
│   ├── Jenkinsfile                 # Pipeline for infra deployment
│   ├── docker.sh                   # Bootstrap script for installing Docker
│   ├── main.tf                     # Terraform config for App EC2 server
│   ├── variables.tf
│   └── pom.xml                     # Maven build file

├── Jenkins_EC2/                    # Jenkins Server Infrastructure
│   ├── install_jenkins.sh          # User data script to install Jenkins
│   ├── main.tf                     # Terraform config for Jenkins EC2
│   ├── variables.tf

├── Jenkinsfile                 # Pipeline for building and deploying app
└── README.md                       # Project documentation
```
## Tech Stack

**Jenkins** – CI/CD automation server
**Terraform** – Infrastructure as Code (IaC) for AWS
**Docker** – Containerization of the Java web app
**Tomcat** – Application server for running the WAR file
**AWS** – Compute instances (Jenkins server + App server)

## Pipeline Flow

### Infrastructure Deployment 
- CI/CD instance is provisioned using Terraform(IaC), bootstrapped to install terraform and Docker
- App instance deployment is automated with Jenkins CI/CD tool, using Terraform plugin, configured to install Docker via terraform config 

### Build and Package
- Jenkins pulls the source code
- Maven build the .war file

### Containerization 
- Dockerfile builds a Tomcat-based image with the WAR
- Image is tagged and pushed to Docker Hub (requires credentials)

### Deployment
- Jenkins SSHes into the App instance
- Stops and removes old container
- Pulls latest Docker image
- Runs new container on port 8080



## Architecture
```mermaid
flowchart TD
    A[Local Machine<br>(Terraform run locally to provision Jenkins EC2)] --> B[Jenkins EC2<br>- Installed via user_data<br>- Runs 2 Pipelines]

    B --> C[Pipeline 1: Infra Deployment<br>- Terraform<br>- Provisions App EC2 instance]
    B --> D[Pipeline 2: Container Deployment<br>- Maven build WAR<br>- Docker build image<br>- Push to Docker Hub<br>- SSH into App EC2<br>- Pull image<br>- Run container (Tomcat + WAR)]

    C --> E[App EC2<br>- Docker installed<br>- Runs container (Tomcat + WAR)]
    D --> E

    E --> F[End Users<br>Access app via:<br>http://<App_server_public_IP>:8080/app]
```


## Setup & Usage

### Deploy Jenkins Instance 
```bash 
 cd Jenkins_EC2
 terraform init
 terraform apply --auto-approve
 ```
 - This provisions a Jenkins server
 - Jenkins is installed using **install_jenkins.sh** 

 ### Configure Jenkins
 - Install required plugins: Docker Pipeline, SSH Agent, Terraform
- Add Credentials: 
• aws_access_key_id
• aws_secret_access_key
• docker-cred (Docker Hub username/password)
• ec2-ssh-key (Instance ssh username/private key)
• instance_type
• kp (key pair name)
• region (AWS region)
• az (AWS region avaialability zone)
• my_ip (Allowed CIDR)
 
**NOTE** 
- Some of these credentials are not secrets, that's just my preference 
- Credentials should be stored in Jenkins Credentials Manager, not in code or plaintext.

### Run Infra-Deployment Pipeline 
- Run the Jenkinsfile in App_EC2/
- Handles App server Deployment 

### Run Container Deployment Pipeline
- Run the Jenkinsfile in root directory
- Builds app with Maven
- Builds image with Dockerfile in App_EC2/
- Push to Docker Hub
- Deploy on App server

#### Once deployed, access the application on 'http://<App_server_public_IP>:8080/app

## Prerequisites
- AWS account with programmatic access (IAM user with EC2, VPC, and IAM permissions)
- Terraform installed locally
- Docker Hub account (for pushing images)
- SSH key pair in AWS
- Maven installed (for local testing, Jenkins handles it in CI/CD)

## Future Improvements
- Add HTTPS with AWS ALB + ACM
- Implement Blue-Green deployment strategy
- Use Ansible for app server configuration instead of bootstrap scripts
- Add monitoring/alerting with CloudWatch


## License

- This project is licensed under the MIT License — See the 'LICENSE' file for full details.
- [MIT License](./LICENSE)


