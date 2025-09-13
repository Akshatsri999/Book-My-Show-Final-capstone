pipeline {
    agent any
    tools {
        jdk 'jdk17'         // Your Jenkins JDK installation name
        nodejs 'nodejs'     // Your Jenkins Node.js installation name
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'  // Your SonarQube Scanner installation
    }
    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/Akshatsri999/Book-My-Show-Final-capstone.git'
                sh 'ls -la'  // Verify files after checkout
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {  // Use your SonarQube server credentials
                    sh ''' 
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=BMS \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://<SONAR_HOST>:9000 \
                    -Dsonar.login=<SONAR_TOKEN>
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
                if [ -f package.json ]; then
                    rm -rf node_modules package-lock.json
                    npm install
                else
                    echo "package.json not found!"
                    exit 1
                fi
                '''
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
                sh 'trivy fs . > trivyfs.txt'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh ''' 
                        docker build --no-cache -t akshatsri999/bookmyshow:latest -f bookmyshow-app/Dockerfile bookmyshow-app
                        docker push akshatsri999/bookmyshow:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy to Docker Container') {
            steps {
                sh ''' 
                docker stop bms || true
                docker rm bms || true
                docker run -d --restart=always --name bms -p 3000:3000 akshatsri999/bookmyshow:latest
                docker ps -a
                docker logs bms
                '''
            }
        }
    }

    post {
        always {
            emailext attachLog: true,
                subject: "'${currentBuild.result}'",
                body: "Project: ${env.JOB_NAME}<br/>" +
                      "Build Number: ${env.BUILD_NUMBER}<br/>" +
                      "URL: ${env.BUILD_URL}<br/>",
                to: 'akshatsri999@gmail.com',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
}
