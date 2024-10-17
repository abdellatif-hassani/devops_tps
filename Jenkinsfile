pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
        DOCKER_IMAGE = "abdellatif2002/web-app1"
        DOCKER_TAG = "v${BUILD_NUMBER}"
        EC2_SERVER = "13.38.117.4"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            }
        }
        stage('Login to DockerHub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Push to DockerHub') {
            steps {
                sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }
        stage('Deploy to EC2') {
            steps {
                script {
                    sshagent(credentials: ['ec2-ssh-key']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_SERVER} '
                                # Verify Docker is running
                                if ! docker info > /dev/null 2>&1; then
                                    echo "Docker is not running or not installed"
                                    exit 1
                                fi

                                # Pull the new image
                                docker pull ${DOCKER_IMAGE}:latest

                                # Stop and remove existing container
                                if docker ps -a | grep -q webapp1; then
                                    docker stop webapp1 || true
                                    docker rm webapp1 || true
                                fi

                                # Run the new container
                                docker run -d -p 80:80 --name webapp1 ${DOCKER_IMAGE}:latest

                                # Clean up old images
                                docker system prune -f
                            '
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check the logs for details.'
        }
    }
}
