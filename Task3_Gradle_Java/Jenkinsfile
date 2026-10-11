pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Java & Gradle') {
            steps {
                sh '''
                    java -version
                    javac -version
                    ./gradlew --version
                '''
            }
        }

        stage('Test') {
            steps {
                sh './gradlew clean test'
            }
        }

        stage('Build') {
            steps {
                sh './gradlew build'
            }
        }

        stage('Archive JAR') {
            steps {
                archiveArtifacts artifacts: 'build/libs/*.jar', fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    mkdir -p /opt/codealpha
                    cp build/libs/CodeAlpha_Gradle_Java-1.0.0.jar /opt/codealpha/
                    java -jar /opt/codealpha/CodeAlpha_Gradle_Java-1.0.0.jar
                '''
            }
        }
    }
}
