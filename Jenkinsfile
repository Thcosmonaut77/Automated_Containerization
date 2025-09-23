pipeline {
    agent any
    environment {
        IMAGE_NAME = 'trippy7/sampleapp'
        REGISTRY_CRED = credentials('docker-cred')
        EC2_HOST = 'ec2-user@54.197.36.28' // replace with EC2 IP
        SSH_CRED = credentials('ec2-ssh-key')
        
    }

    stages {
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
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
                      ssh -o StrictHostKeyChecking=no $EC2_HOST \\
                      'docker stop app || true && docker rm app || true && \\
                       docker pull ${IMAGE_NAME}:${BUILD_NUMBER} && \\
                       docker run -d --name app -p 8080:8080 ${IMAGE_NAME}:${BUILD_NUMBER}'
                    """
                }
            }
        }
    }
}
