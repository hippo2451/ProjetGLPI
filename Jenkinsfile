pipeline {
    agent any
    stages {
        
        stage('nettoyage workspace') {
            steps {
                cleanWs()
            }
        }
  
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
    
        
           stage ("wait for staging instance to start") {
            steps {
                withCredentials([[
    $class: 'AmazonWebServicesCredentialsBinding',
    credentialsId: "aws_terraform",
    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]){
        sh '''
          cd ./terraform/staging/
          aws ec2 wait instance-status-ok --region us-east-1 --instance-ids `$(terraform output -json ec2_id_test) | awk -F'"' '{print $2}'`
        '''
      }
    }
   }

    stage ("deploy ansible playbook") {
            steps {
           
                ansiblePlaybook colorized: true, credentialsId: 'open_ssh_aws', disableHostKeyChecking: true, inventory: 'terraform/staging/hosts', playbook: 'ansible/deploy.yml'
                }
           }
        
    
        stage('proceed to deploy on prod') {
            input {
                message "Should we deploy on prod?"
                ok "Yes, we should."
              
                }
            }
    }
}
