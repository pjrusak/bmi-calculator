def projectName = 'bmi-calculator'

pipeline {
    agent none

    stages {
        stage('SCM checkout') {
            steps {
                git branch: 'master',
                    url: "https://github.com/pjrusak/${projectName}.git"
            }
        }
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

