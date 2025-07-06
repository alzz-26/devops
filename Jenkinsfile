pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'inventory-management'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        MAVEN_OPTS = '-Dmaven.repo.local=.m2/repository'
    }
    
    tools {
        maven 'Maven-3.8.4'
        jdk 'JDK-11'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from Git repository'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application with Maven'
                sh 'mvn clean compile'
            }
        }
        
        stage('Unit Tests') {
            steps {
                echo 'Running unit tests with JUnit'
                sh 'mvn test'
            }
            post {
                always {
                    echo 'Publishing test results'
                    publishTestResults testResultsPattern: '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Code Coverage') {
            steps {
                echo 'Generating code coverage report with JaCoCo'
                sh 'mvn jacoco:report'
            }
            post {
                always {
                    echo 'Publishing code coverage report'
                    publishCoverage adapters: [jacocoAdapter('**/target/site/jacoco/jacoco.xml')], 
                                   sourceFileResolver: sourceFiles('STORE_LAST_BUILD')
                }
            }
        }
        
        stage('SonarQube Analysis') {
            when {
                branch 'main'
            }
            steps {
                echo 'Running SonarQube analysis'
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                echo 'Running security vulnerability scan'
                sh 'mvn dependency:check'
            }
        }
        
        stage('Integration Tests') {
            steps {
                echo 'Running integration tests'
                sh 'mvn verify -Dskip.unit.tests=true'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        
        stage('Docker Security Scan') {
            steps {
                echo 'Scanning Docker image for vulnerabilities'
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_IMAGE}:${DOCKER_TAG}'
            }
        }
        
        stage('Push to Registry') {
            when {
                branch 'main'
            }
            steps {
                echo 'Pushing Docker image to registry'
                script {
                    docker.withRegistry('https://registry.example.com', 'registry-credentials') {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to staging environment'
                script {
                    sh '''
                        docker-compose -f docker-compose.staging.yml down
                        docker-compose -f docker-compose.staging.yml up -d
                    '''
                }
            }
        }
        
        stage('Staging Tests') {
            when {
                branch 'main'
            }
            steps {
                echo 'Running tests against staging environment'
                script {
                    sh '''
                        sleep 30
                        curl -f http://staging-inventory-app:8080/actuator/health
                        mvn test -Dtest=StagingIntegrationTest
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to production environment'
                script {
                    sh '''
                        docker-compose -f docker-compose.prod.yml down
                        docker-compose -f docker-compose.prod.yml up -d
                    '''
                }
            }
        }
        
        stage('Health Check') {
            when {
                branch 'main'
            }
            steps {
                echo 'Performing health check on production'
                script {
                    sh '''
                        sleep 60
                        curl -f http://prod-inventory-app:8080/actuator/health
                        curl -f http://prod-inventory-app:8080/api/products
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
            emailext (
                subject: "Pipeline SUCCESS: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "Pipeline completed successfully. Build: ${env.BUILD_URL}",
                to: 'devops-team@company.com'
            )
        }
        failure {
            echo 'Pipeline failed!'
            emailext (
                subject: "Pipeline FAILED: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                body: "Pipeline failed. Build: ${env.BUILD_URL}",
                to: 'devops-team@company.com'
            )
        }
        unstable {
            echo 'Pipeline is unstable!'
        }
    }
} 