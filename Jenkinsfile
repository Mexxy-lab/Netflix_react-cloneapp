pipeline {
    agent any
    options {
        timeout(time: 20, unit: 'MINUTES')
    }
    stages{
        // NPM dependencies
        stage('pull npm dependencies') {
            steps {
                sh 'yarn install'
            }
        }
       stage('build Docker Image') {
            steps {
                script {
                    // build image
                    docker.build("598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:latest")
               }
            }
        }
        stage('Trivy Scan (Aqua)') {
            steps {
                sh 'trivy image --format template --output trivy_report.html 598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:latest'
            }
       }
        stage('Push to ECR') {
            steps {
                script{
                    //https://<AwsAccountNumber>.dkr.ecr.<region>.amazonaws.com/netflix-app', 'ecr:<region>:<credentialsId>
                    docker.withRegistry('598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo', 'ecr:ap-south-1:pumejawsacr') {
                    // build image
                    def myImage = docker.build("598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:v1.0.0")
                    // push image
                    myImage.push()
                    }
                }
            }
        }
        
    }
}