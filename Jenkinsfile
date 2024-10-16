pipeline {

    agent any

    

    environment {

        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')

        // Replace with your DockerHub username and repository name

        DOCKER_IMAGE = "abdellatif2002/web-app1"  // Change this to your DockerHub username/repository

        DOCKER_TAG = "v${BUILD_NUMBER}"

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

                sshagent(['ec2-ssh-key']) {

                    sh '''

                        ssh -o StrictHostKeyChecking=no ubuntu@35.180.109.66 '  # Replace with your EC2 IP

                            docker pull ${DOCKER_IMAGE}:latest

                            docker stop webapp1 || true

                            docker rm webapp1 || true

                            docker run -d -p 80:80 --name webapp1 ${DOCKER_IMAGE}:latest

                        '

                    '''

                }

            }

        }

    }

    

    post {

        always {

            sh 'docker logout'

        }

    }

}
