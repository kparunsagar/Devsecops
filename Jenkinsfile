pipeline {
    agent any
    
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    
    stages{
        
        stage("Git Checkout"){
            steps{
                git branch: 'acr', changelog: false, poll: false, url: 'https://github.com/kparunsagar/Devsecops-PetclincApplication.git'
            }
        }  
        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }
        stage("Test Cases"){
            steps{
                sh "mvn test"
            }
        }
        stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }
        stage("Build docker image"){
            steps {
                sh 'docker build -t arunregistry77.azurecr.io/petclinic:${BUILD_NUMBER} .'
            }
        }
        stage('Upload Image to ACR') {
            steps{   
                script {
                    withcredentials([usernamePassword(credentialsId: 'azurecontainerregistry', PasswordVariable: 'password', usernameVariable: 'username')]) {
                    sh 'docker login -u ${username} -p ${password} arunregistry77.azurecr.io'
                    sh 'docker image push arunregistry77.azurecr.io/petclinic:${BUILD_NUMBER} '
                    }
                }
            }
        }
    }
}
