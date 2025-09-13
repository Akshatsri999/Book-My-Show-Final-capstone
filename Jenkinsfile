pipeline {
    agent any

    tools {
        jdk 'jdk17'              // Your configured JDK in Jenkins
        nodejs 'node23'          // Your configured Node.js installation name
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'   // Must match your Jenkins SonarScanner installation name
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
                sh 'ls -la'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {   // Must match SonarQube server name in Jenkins
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=BookMyShow \
                        -Dsonar.projectName="Book My Show" \
                        -Dsonar.sources=.
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: true, credentialsId: 'Sonar-token'
                }
            }
        }
    }
}
