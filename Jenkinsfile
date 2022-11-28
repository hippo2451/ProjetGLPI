pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
        
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/hippo2451/ProjetGLPI.git']]])

          }
        }
        
        stage ("terraform init") {
            steps {
                withCredentials([[
    $class: 'AmazonWebServicesCredentialsBinding',
    credentialsId: "aws_terraform",
    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]){
                sh '''cd ./terraform/staging/
              terraform init 
              '''
                }
            }
        }
        
        stage ("apply") {
            steps {
                withCredentials([[
    $class: 'AmazonWebServicesCredentialsBinding',
    credentialsId: "aws_terraform",
    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]){
                sh ('terraform apply -auto-approve') 
                }
           }
        }
    }
}
