pipeline {
    agent any
    
    tools {
        maven 'maven'
        jdk 'JDK'
    }
    
    environment {
        // Set specific versions to match your environment
        REQUIRED_JDK_VERSION = '21'
        REQUIRED_MAVEN_VERSION = '3.9'
    }
    
    stages {
        stage('Environment Check') {
            steps {
                script {
                    echo "=== VERIFYING BUILD ENVIRONMENT ==="
                    
                    // Check Java version
                    def javaVersion = sh(script: 'java -version 2>&1 | head -n 1', returnStdout: true).trim()
                    echo "✅ Java Version: ${javaVersion}"
                    
                    // Check Maven version
                    def mavenVersion = sh(script: 'mvn --version | head -n 1', returnStdout: true).trim()
                    echo "✅ Maven Version: ${mavenVersion}"
                    
                    // Validate versions
                    if (!javaVersion.contains('version "21')) {
                        error "❌ Java version mismatch. Expected JDK 21, but found: ${javaVersion}"
                    }
                    
                    if (!mavenVersion.contains('3.9')) {
                        error "❌ Maven version mismatch. Expected 3.9.x, but found: ${mavenVersion}"
                    }
                    
                    echo "🎉 Environment validation passed! All tools are correctly installed."
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
                    echo "Building with JDK 21 and Maven 3.9.11..."
                    sh 'mvn clean compile test package'
                }
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                    archiveArtifacts 'target/*.jar'
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
                        COPY target/task-manager-backend-0.0.1-SNAPSHOT.jar app.jar
                        EXPOSE 8080
                        ENTRYPOINT ["java", "-jar", "app.jar"]
                        EOF
                    '''
                    sh 'docker build -t task-manager-backend:jdk21 .'
                }
            }
        }
    }
    
    post {
        always {
            echo "=== BUILD COMPLETE ==="
            echo "Java: OpenJDK 21.0.8"
            echo "Maven: 3.9.11"
            echo "Status: ${currentBuild.result ?: 'SUCCESS'}"
        }
    }
}