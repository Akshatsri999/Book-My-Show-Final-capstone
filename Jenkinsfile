pipeline {
    agent any

    tools {
        jdk 'jdk17'            // Make sure this JDK is configured in Jenkins
        nodejs 'node23'        // Make sure this NodeJS installation exists
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'  // Make sure this is configured in Jenkins
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from GitHub') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git',
                    credentialsId: 'github-credentials'  // Use your GitHub token credential ID
                sh 'ls -la' // Verify files after checkout
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh """ 
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=BMS \
                    -Dsonar.projectName=BMS \
                    -Dsonar.sources=. 
                    """
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh """
                if [ -f package.json ]; then
                    rm -rf node_modules package-lock.json
                    npm install
                else
                    echo "package.json not found!"
                    exit 1
                fi
                """
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs . > trivyfs.txt || echo "Trivy scan failed, continue..."'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                        sh """
                        docker build -t akshatsri999/bookmyshow:latest .
                        docker push akshatsri999/bookmyshow:latest
                        """
                    }
                }
            }
        }

        stage('Deploy to Docker') {
            steps {
                sh """
                docker stop bms || true
                docker rm bms || true
                docker run -d --restart=always --name bms -p 3000:3000 akshatsri999/bookmyshow:latest
                docker ps -a
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline finished. Check Docker container and SonarQube results."
        }
    }
}
