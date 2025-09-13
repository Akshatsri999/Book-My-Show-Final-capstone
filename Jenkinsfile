pipeline {
    agent any

    environment {
        // Replace with your actual SonarQube EC2 public IP
        SONAR_HOST = "http://YOUR_EC2_PUBLIC_IP:9000"
        SONAR_TOKEN = "YOUR_GENERATED_SONAR_TOKEN"

        // Docker credentials ID configured in Jenkins
        DOCKER_CRED = "dockerhub-credentials"

        // NodeJS installation name configured in Jenkins
        NODEJS_NAME = "node23"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'main', credentialsId: 'GitHub-Access-Token', url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                // Use NodeJS configured in Jenkins
                nodejs(NODEJS_NAME) {
                    sh 'npm install'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=BookMyShow \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONAR_HOST} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
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

        stage('Docker Build & Push') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CRED) {
                        def app = docker.build("akshatsri999/bookmyshow:latest")
                        app.push()
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh """
                    docker stop bookmyshow || true
                    docker rm bookmyshow || true
                    docker run -d --name bookmyshow -p 8080:8080 akshatsri999/bookmyshow:latest
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Check Docker container and SonarQube results."
        }
        failure {
            mail to: 'akshatsri999@gmail.com',
                 subject: "Jenkins Pipeline Failed: ${currentBuild.fullDisplayName}",
                 body: "Check the Jenkins logs for details."
        }
    }
}

