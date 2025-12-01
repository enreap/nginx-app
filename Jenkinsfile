pipeline {
    agent any
    tools {
        snyk 'snyk'  // This must match the Snyk installation name in Jenkins
    }

    environment {
        // Repository & Branch
        GIT_REPO_URL = 'https://github.com/enreap/nginx-app.git'
        BRANCH_NAME  = 'main'

        // Jenkins tool configurations
        MAVEN_HOME = tool 'maven'
        JAVA_HOME  = tool 'jdk-21'
        SONARQUBE_ENV = 'sonar-scanner'    // MUST match Jenkins configuration
        
        // Docker
        DOCKER_IMAGE = "enreapdevopsteam/sonar-java-demo"
        DOCKER_USERNAME = "enreapdevopsteam"
        DOCKER_PAT = "dckr_pat_rXL6w8JnJahrGp06JlL1TVPW-gk"
        PATH = "${JAVA_HOME}/bin:${PATH}"
        //snyk
        // snyk = tool 'snyk'
        SNYK_TOKEN = credentials('SNYK_TOKEN')
        SNYK_MAVEN_EXECUTABLE = 'mvn'
        PROJECT_DIR = "sonar-project-demo"

    }

    stages {

        stage('Checkout') {
            steps {
                echo "Cloning code from ${GIT_REPO_URL} (branch: ${BRANCH_NAME})"
                git branch: "${BRANCH_NAME}", url: "${GIT_REPO_URL}"
            }
        }
        // stage('TruffleHog Secret Scan') {
        //     steps {
        //         sh 'trufflehog filesystem . --json > trufflehog-report.json'
        //     }
        // }
        // stage('Trivy FS Scan') {
        //     steps {
        //         sh '''
        //             trivy fs . --severity HIGH,CRITICAL \
        //             --format json --output trivy-fs-report.json
        //         '''	
        //     }
        //     post {
        //         always { archiveArtifacts 'trivy-fs-report.json' }
        //     }
        // }        

        // stage('Build with Maven') {
        //     steps {
        //         echo "Building with Maven (JDK 21)..."
        //         sh "${MAVEN_HOME}/bin/mvn clean install -DskipTests"
        //     }
        // }

        // stage('SonarQube Analysis') {
        //     steps {
        //         echo "Running SonarQube static code analysis..."
        //         withSonarQubeEnv("${SONARQUBE_ENV}") {
        //             withCredentials([string(credentialsId: 'sonartoken1', variable: 'SONAR_TOKEN')]) {
        //                 sh """
        //                     ${MAVEN_HOME}/bin/mvn clean verify sonar:sonar \\
        //                         -Dsonar.projectKey=Java-sonar-jenkins-Demo \\
        //                         -Dsonar.projectName='Java-sonar-jenkins-Demo' \\
        //                         -Dsonar.host.url=http://3.216.226.173:9000 \\
        //                         -Dsonar.login=sqp_157b895816c9e77187cce1d9092f10a00c4c8c55 \\
        //                         -Dsonar.qualitygate.wait=true
        //                 """
        //             }
        //         }
        //     }
        // }

        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             echo "Waiting for Quality Gate..."
        //             timeout(time: 5, unit: 'MINUTES') {
        //                 waitForQualityGate abortPipeline: true
        //             }
        //         }
        //     }
        // }
        // stage('Snyk Code/Dependency Scan') {
        //     steps {
        //         withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
        //             dir('sonar-project-demo') {
        //                 sh '''
        //                     snyk auth $SNYK_TOKEN
        //                     #./mvnw dependency:tree -DoutputType=dot --batch-mode --non-recursive
        //                     snyk test --severity-threshold=low
        //                     snyk monitor --package-manager=maven --all-projects --command=./mvnw    // Upload scan report
        //                  '''
        //             }
        //         }
        //     }
        // }    
        stage('Snyk Code Scan') {
            steps {
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh """
                        snyk auth $SNYK_TOKEN
                        snyk code test html --severity-threshold=medium
                        # If you have dependencies (package.json, pom.xml), uncomment:
                        # snyk test --severity-threshold=medium
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh '''
                    trivy image $DOCKER_IMAGE:${BUILD_NUMBER} \
                    --severity HIGH,CRITICAL \
                     --format json --output trivy-image-report.json
                 '''
            }
            post {
                always { archiveArtifacts 'trivy-image-report.json' }
            }
        }
        stage('Snyk Container Scan') {
            steps {
                sh "snyk auth ${SNYK_TOKEN}"
                sh "snyk container test ${DOCKER_IMAGE}:${BUILD_NUMBER} --severity-threshold=medium"
            }
        }        
        // stage('Push Docker Image') {
        //     steps {
        //         sh """
        //             echo $DOCKER_PAT | docker login -u $DOCKER_USERNAME --password-stdin
        //             docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
        //         """
        //     }
        // }
    }

    post {
        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
        success {
            echo 'pipeline completed successfully!'
        }
        failure {
            echo 'pipeline failed — check logs for details.'
        }
    }
}
