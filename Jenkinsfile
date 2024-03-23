pipeline {
    agent any
    
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        //once you sign up for Docker hub, use that user_id here
        registry = "arunregistry77/petclinic"
        //- update your credentials ID after creating credentials for connecting to Docker Hub
        registryCredential = 'azurecontainerregistry'
        dockerImage = ''
        registryUrl = 'arunregistry77.azurecr.io'
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
                sh 'docker build -t arunregistry77/petclinic:$BUILD_NUMBER .'
            }
        }
        stage('Upload Image to ACR') {
             steps{   
                 script {
                    docker.withRegistry( "http://${registryUrl}", registryCredential ) {
                    dockerImage.push()
                    }
                }
              }
        }

    }
}
