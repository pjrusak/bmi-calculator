pipeline {
    agent {
        docker {
            image 'node:16.13.1-alpine'
        }
    }

    stages {
        stage('install dependencies') {
            steps {
                echo 'Building nodejs app...'
                sh '''
                    npm version
                    npm clean-install
                '''
            }
        }
        stage('unit tests'){
            steps {
                echo 'Running UTs...'
                sh '''
                    CI=true npm run test -- --coverage \
                        --watchAll=false --ci \
                        --reporters=default \
                        --coverageReporters=cobertura
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'coverage/*.*', followSymlinks: false,
                        fingerprint: true
                    cobertura autoUpdateHealth: false, autoUpdateStability: false,
                        coberturaReportFile: 'coverage/cobertura-coverage.xml',
                        conditionalCoverageTargets: '70, 0, 0', failNoReports: false,
                        failUnhealthy: false, failUnstable: false,
                        lineCoverageTargets: '70, 0, 0', maxNumberOfBuilds: 0,
                        methodCoverageTargets: '70, 0, 0', onlyStable: false,
                        sourceEncoding: 'ASCII'
                }
            }
        }
        stage('build') {
            steps {
                echo 'Building application...'
                sh '''
                    npm run build
                '''
                zip zipFile: 'build.zip', archive: false, dir: './build'
                echo 'Stash build artifact...'
                stash name: 'app-build-stash', allowEmpty: false, includes: 'build.zip'
                echo 'Stash Dockerfile...'
                stash name: 'dockerfile', allowEmpty: false, includes: 'Dockerfile'
                slackSend channel: "#channel-name", failOnError: false, 
                    message: "Build ${env.JOB_NAME} ${env.BUILD_NUMBER} stashed."
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build.zip', fingerprint: true
                }
            }
        }
        stage('build docker') {
            agent any

            steps {
                dir('app-build-stash') {
                    unstash 'app-build-stash'
                    unzip 'build.zip'
                    sh 'rm -f build.zip'
                }
                unstash 'dockerfile'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'cicd-docker-registry') {
                        def webAppImage = docker.build('calculator-bmi', "--build-arg webApp=app-build-stash", '-f Dockerfile .')
                        webAppImage.push()
                    }
                }
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
