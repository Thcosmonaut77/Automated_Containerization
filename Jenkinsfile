pipeline {
    agent any
    environment {
        IMAGE_NAME   = 'trippy7/sampleapp'
        REGISTRY_CRED = 'docker-cred'   // Jenkins credentials ID for Docker Hub
        EC2_HOST     = 'ubuntu@54.84.89.137'  // replace with EC2 public IP
        SSH_CRED     = 'ec2-ssh-key'   // Jenkins credentials ID for EC2 SSH key
    }

    stages {
        stage('Build with Maven') {
            steps {
                dir('App_EC2') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}", "App_EC2")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CRED) {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent([SSH_CRED]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $EC2_HOST \
                        'docker stop app || true && docker rm app || true && \\
                         docker pull ${IMAGE_NAME}:${BUILD_NUMBER} && \\
                         docker run -d --name app -p 8080:8080 ${IMAGE_NAME}:${BUILD_NUMBER}'
                    """
                }
            }
        }
    }
}
