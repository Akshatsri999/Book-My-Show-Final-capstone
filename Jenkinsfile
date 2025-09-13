pipeline {
    agent any

    environment {
        // Replace 'sonar-server' with the name of your configured SonarQube installation in Jenkins
        SONARQUBE_ENV = 'sonar-server'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git',
                    credentialsId: 'GitHub-Access-Token' // your GitHub credentials
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE_ENV) {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
