pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node23'
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')  // create in Jenkins
    }
    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {   // must match Jenkins SonarQube config
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t bookmyshow-app:latest .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh """
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker tag bookmyshow-app:latest your-dockerhub-username/bookmyshow-app:latest
                        docker push your-dockerhub-username/bookmyshow-app:latest
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh """
                        docker rm -f bookmyshow-app || true
                        docker run -d --name bookmyshow-app -p 8080:8080 your-dockerhub-username/bookmyshow-app:latest
                    """
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
