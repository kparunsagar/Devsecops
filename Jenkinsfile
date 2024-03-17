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
        }
    stage('Packaging') {
      steps {
        step([$class: 'ArtifactArchiver', artifacts: '**/target/*.jar ', fingerprint: true])
      }
    }         
    stage ("Artifactory Publish"){
      steps {
        script{
          def server = Artifactory.server 'Artifactory'
          def rtMaven = Artifactory.newMavenBuild()
          //rtMaven.resolver server: server, releaseRepo: 'jenkinsdemo_repo', snapshotRepo: 'demopipeline'
          rtMaven.deployer server: server, releaseRepo: 'pet-release', snapshotRepo: 'pet-snapshot'
          rtMaven.tool = 'maven'
                            
          def buildInfo = rtMaven.run pom: '$workspace/pom.xml', goals: 'clean install'
          rtMaven.deployer.deployArtifacts = true
          rtMaven.deployer.deployArtifacts buildInfo
          server.publishBuildInfo buildInfo
        }
      }
    }

  }
}
