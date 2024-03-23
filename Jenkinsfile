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
        stage('build the code'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('build the docker image from docker file'){
            steps{
                sh 'docker image build -t arunregistry77.azurecr.io/petclinic:${BUILD_NUMBER} .'
            }
        }
        stage('azure login and push the docker image to acr hub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'azurecontainerregistry', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh 'docker login -u ${username} -p ${password} arunregistry77.azurecr.io'
                sh 'docker image push arunregistry77.azurecr.io/petclinic:${BUILD_NUMBER} '
                 }
            }
        }
    }
}
