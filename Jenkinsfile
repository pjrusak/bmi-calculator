pipeline {
    agent none

    stages {
        stage('npm install') {
            steps {
	        echo 'npm install'
            }
        }
        stage('build app'){
            steps {
	        echo 'building application'
            }
        }
        stage('unit tests'){
            steps {
	        echo 'running unit tests'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}

