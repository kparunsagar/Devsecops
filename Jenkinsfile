pipeline {
    agent any
    
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('Artifactory')
    }
    
    stages{
        
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/kparunsagar/Devsecops-PetclincApplication.git'
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
        stage('Upload to Artifactory') {
            agent {
                docker {
                    image 'releases-docker.jfrog.io/jfrog/jfrog-cli-v2:2.2.0' 
                        reuseNode true
                }
            }
            steps {
                sh 'jfrog rt upload --url http://20.244.86.184:8082/artifactory/ --access-token ${ARTIFACTORY_ACCESS_TOKEN} target/petclinc-SNAPSHOT.jar petclinc/'
            }
        }
  }
}
