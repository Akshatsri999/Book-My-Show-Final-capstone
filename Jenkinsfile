pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                        sonar-scanner \
                          -Dsonar.projectKey=bookmyshow-capstone \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=http://<EC2-PUBLIC-IP>:9000 \
                          -Dsonar.login=${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
