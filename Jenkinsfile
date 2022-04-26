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
                stash name: 'app-build-stash', allowEmpty: false, includes: 'build.zip'
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
                script {
                    def dockerfile = """\
                        FROM nginx:1.21.6-alpine
                        USER nginx
                        COPY --chown=nginx:nginx ./app-build-stash /usr/share/nginx/html
                        EXPOSE 80
                        CMD ["nginx", "-g", "daemon off;"]
                    """.stripIndent()
                    writeFile(file: 'Dockerfile', text: dockerfile)

                    docker.withRegistry('https://registry.hub.docker.com', 'cicd-docker-registry') {
                        def webAppImage = docker.build('calculator-bmi', '-f Dockerfile .')
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
