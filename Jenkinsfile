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
                    docker.build("598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:v1.0.0")
               }
            }
       }
       stage('Trivy Scan (Aqua)') {
            steps {

                sh 'trivy image --format template --output trivy_report.html 598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:v1.0.0'
            }
       }
        stage('Push to AWS ECR') {
             steps {
                  script{
                        //https://AwsAccountNumber.dkr.ecr.region.amazonaws.com/rekeyole-app', 'ecr:region:credentialsId
                        docker.withRegistry('https://598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo', 'ecr:ap-south-1:aws_ecr_repo'){

                         // Tagging image
                         def myImage = docker.build("598189530267.dkr.ecr.ap-south-1.amazonaws.com/pumejrepo:v1.0.0")

                           // pushing image upload....
                         myImage.push()
                         }
                  }
             }
        }
        
    }
}