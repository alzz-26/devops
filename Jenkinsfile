pipeline {
    agent any
    
    tools {
        maven 'Maven 3.8.4'
        jdk 'JDK 11'
    }
    
    environment {
        DOCKER_IMAGE = 'inventory-management-system'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'mvn clean compile'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh 'mvn test'
            }
        }
        
        stage('Package') {
            steps {
                echo 'Packaging the application...'
                sh 'mvn package -DskipTests'
            }
        }
        
        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        
        stage('Deploy with Ansible') {
            steps {
                echo 'Deploying with Ansible...'
                sh 'ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags deploy'
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        
        success {
            echo 'Pipeline completed successfully!'
        }
        
        failure {
            echo 'Pipeline failed!'
        }
    }
} 
