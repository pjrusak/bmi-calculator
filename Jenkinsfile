pipeline {
    agent any

    stages {
        stage('npm install') {
            agent {
                docker {
                    image 'node:16.13.1-alpine'
                }
            }
            steps {
                echo 'Installing nodejs modules...'
                sh '''
                    npm version
                    npm install
                '''
            }
        }
        stage('build app'){
            steps {
                echo 'Building nodejs application...'
                sh 'npm build'
            }
        }
        stage('unit tests'){
            steps {
                echo 'Running UTs...'
                sh 'npm test'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
