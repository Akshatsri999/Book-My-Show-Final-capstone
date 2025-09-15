pipeline {
    agent any

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=bookmyshow-akshat \
                        -Dsonar.projectName=bookmyshow-akshat \
                        -Dsonar.sources=.
                    """
                }
            }
        }

        stage('Docker Build, Tag, Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker build -t bookmyshow-25:v1 .'
                        sh 'docker tag bookmyshow-25:v1 akshatsri999/bookmyshow-25:v1'
                        sh 'docker push akshatsri999/bookmyshow-25:v1'
                    }
                }
            }
        }

        stage('Deploy to Container') {
            steps {
                script {
                    sh 'docker rm -f bookmyshow-container || true'
                    sh 'docker run -d --name bookmyshow-container -p 3000:3000 akshatsri999/bookmyshow-25:v1'
                }
            }
        }
    }
}
