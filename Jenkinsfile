pipeline {
    agent any
    
    tools {
        maven 'maven'
        jdk 'JDK'
    }
    
    environment {
        REQUIRED_JDK_VERSION = '21'
        REQUIRED_MAVEN_VERSION = '3.9'
    }
    
    stages {
        stage('Environment Check') {
            steps {
                script {
                    echo "=== VERIFYING BUILD ENVIRONMENT ==="
                    
                    def javaVersion = sh(script: 'java -version 2>&1 | head -n 1', returnStdout: true).trim()
                    echo "✅ Java Version: ${javaVersion}"
                    
                    def mavenVersion = sh(script: 'mvn --version | head -n 1', returnStdout: true).trim()
                    echo "✅ Maven Version: ${mavenVersion}"
                    
                    if (!javaVersion.contains('version "21')) {
                        error "❌ Java version mismatch. Expected JDK 21, but found: ${javaVersion}"
                    }
                    
                    echo "🎉 Environment validation passed!"
                }
            }
        }
        
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/prashanty3/java_project.git'
            }
        }
        
        stage('Build & Test') {
            steps {
                script {
                    echo "Building Spring Boot 3.5.0 with Java 21..."
                    sh 'mvn clean compile test package'
                }
            }
            post {
                always {
                    script {
                        // Only publish test results if they exist
                        if (fileExists('target/surefire-reports')) {
                            junit 'target/surefire-reports/*.xml'
                        } else {
                            echo "No test reports found - tests may have been skipped"
                        }
                        if (fileExists('target/*.jar')) {
                            archiveArtifacts 'target/*.jar'
                        }
                    }
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                        cat > Dockerfile << 'EOF'
                        FROM openjdk:21-jdk-slim
                        WORKDIR /app
                        COPY target/tasks-0.0.1-SNAPSHOT.jar app.jar
                        EXPOSE 8080
                        ENTRYPOINT ["java", "-jar", "app.jar"]
                        EOF
                    '''
                    sh 'docker build -t task-manager-backend:latest .'
                    sh 'docker images | grep task-manager-backend'
                }
            }
        }
    }
    
    post {
        always {
            echo "=== BUILD COMPLETE ==="
            echo "Project: ${env.JOB_NAME}"
            echo "Build: ${env.BUILD_NUMBER}"
            echo "Java: 21"
            echo "Spring Boot: 3.5.0"
            echo "Status: ${currentBuild.result ?: 'SUCCESS'}"
        }
        success {
            echo "✅ Spring Boot 3.5.0 with Java 21 build successful!"
        }
        failure {
            echo "❌ Build failed - check Java 21 compatibility"
        }
    }
}