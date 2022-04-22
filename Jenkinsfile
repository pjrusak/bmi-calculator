pipeline {
    agent none

    stages {
        stage('install dependencies') {
            agent {
                docker {
                    image 'node:16.13.1-alpine'
                }
            }
            steps {
                echo 'Building nodejs app...'
                sh '''
                    npm version
                    npm clean-install
                '''
            }
        }
        stage('unit tests'){
            agent {
                docker {
                    image 'node:16.13.1-alpine'
                    reuseNode true
                }
            }
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
            agent {
                docker {
                    image 'node:16.13.1-alpine'
                    reuseNode true
                }
            }
            steps {
                echo 'Building application...'
                sh '''
                    npm run build
                '''
                zip zipFile: 'build.zip', archive: false, dir: './build'
                stash name: 'app-build-stash', allowEmpty: false, includes: 'build.zip'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build.zip', fingerprint: true
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
