pipeline {
    agent any

    tools {
        jdk 'jdk17'              // must match Jenkins JDK name
        nodejs 'node23'          // must match Jenkins NodeJS name
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'   // must match Jenkins SonarScanner name
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
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {   // must match SonarQube server name in Jenkins
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
