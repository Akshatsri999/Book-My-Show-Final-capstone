pipeline {
    agent any

    environment {
        SONAR_HOST_URL = 'http://<SONARQUBE_IP>:9000'  // Replace with your SonarQube server IP
        SONAR_TOKEN = credentials('sonar-token')       // Add your SonarQube token in Jenkins credentials
    }

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    sh """
                    docker run --rm \
                        -e SONAR_HOST_URL=${SONAR_HOST_URL} \
                        -e SONAR_LOGIN=${SONAR_TOKEN} \
                        -v $WORKSPACE:/usr/src sonarsource/sonar-scanner-cli
                    """
                }
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh 'docker build -t bookmyshow:v1 .'
                        sh 'docker tag bookmyshow:v1 akshatsri999/bookmyshow:v1'
                        sh 'docker push akshatsri999/bookmyshow:v1'
                    }
                }
            }
        }

        stage('Deploy to Container') {
            steps {
                sh 'docker run -d --name bookmyshow-app -p 3130:3130 akshatsri999/bookmyshow:v1'
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig(credentialsId: 'k8s-config', namespace: 'akshat-ns') {
                        sh 'kubectl apply -f deployment.yml'
                        sh 'kubectl apply -f service.yml'
                        sh 'kubectl apply -f usernode-js-service.yml'
                        sh 'kubectl apply -f userprofile-deployment.yml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs!'
        }
    }
}
