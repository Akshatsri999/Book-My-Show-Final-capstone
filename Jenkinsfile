pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('dockerhub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git',
                    credentialsId: 'GitHub-Access-Token'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t bookmyshow-app:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                    echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
                    docker tag bookmyshow-app:latest $DOCKERHUB_USR/bookmyshow-app:latest
                    docker push $DOCKERHUB_USR/bookmyshow-app:latest
                """
            }
        }

        stage('Deploy to Docker') {
            steps {
                sh 'docker run -d -p 8080:8080 --name bookmyshow-app bookmyshow-app:latest || true'
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Please check logs."
        }
        success {
            echo "Pipeline completed successfully!"
        }
    }
}
