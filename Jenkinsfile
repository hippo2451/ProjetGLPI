pipeline {
    agent any
    
    stages {
        stage('nettoyage workspace') {
            steps {
                cleanWs()
            }
        }

    stages {
        stage('Checkout') {
            steps {
        
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/hippo2451/ProjetGLPI.git']]])

          }
        }
        
        stage ("terraform init staging") {
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
        
        stage ("apply staging") {
            steps {
                withCredentials([[
    $class: 'AmazonWebServicesCredentialsBinding',
    credentialsId: "aws_terraform",
    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]){
                sh '''cd ./terraform/staging/
                    terraform apply -auto-approve'''
                }
           }
        }
    
    stage ("deploy ansible playbook") {
            steps {
           
                ansiblePlaybook colorized: true, credentialsId: 'open_ssh_aws', disableHostKeyChecking: true, inventory: 'terraform/staging/hosts', playbook: 'ansible/deploy.yml'
                }
           }
        
    
    }
}
