pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node23'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
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
                withSonarQubeEnv('sonar-server') {
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=BMS \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://<your-sonarqube-server>:9000 \
                    -Dsonar.login=<sonar-token>
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh '''
                cd bookmyshow-app
                npm install
                '''
            }
        }
        stage('OWASP FS Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs . > trivyfs.txt'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh '''
                        docker build -t akshatsri999/bookmyshow:latest bookmyshow-app
                        docker push akshatsri999/bookmyshow:latest
                        '''
                    }
                }
            }
        }
        stage('Deploy to Container') {
            steps {
                sh '''
                docker stop bms || true
                docker rm bms || true
                docker run -d --restart=always -p 3000:3000 --name bms akshatsri999/bookmyshow:latest
                docker ps -a
                docker logs bms
                '''
            }
        }
    }
    post {
        always {
            emailext attachLog: true,
                subject: "Build ${currentBuild.result}",
                body: "Project: ${env.JOB_NAME}<br/>Build Number: ${env.BUILD_NUMBER}<br>URL: ${env.BUILD_URL}",
                to: 'akshatsri999@gmail.com',
                attachmentsPattern: 'trivyfs.txt'
        }
    }
}
