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
				echo 'Installing nodejs modules'
				sh '''
					npm version
					npm install
				'''
				
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

