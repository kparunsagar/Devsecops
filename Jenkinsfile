pipeline {
    agent any
    
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        SCANNER_HOME=tool 'sonarQube'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
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
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonarQube') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=petclinic '''
                }
            }
        }
        stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }
        stage('Packaging') {
            steps {
                step([$class: 'ArtifactArchiver', artifacts: '**/target/*.war ', fingerprint: true])
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
        stage("Build docker image"){
            steps {
                sh 'docker build -t kparun/petclinic:$BUILD_NUMBER .'
            }
        }
        stage("Login to docker hub"){
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage("Docker push"){
            steps {
                sh 'docker push kparun/petclinic:$BUILD_NUMBER'
            }
        }
    stage("TRIVY"){
      steps{
        sh " trivy image kparun/petclinic:$BUILD_NUMBER"
      }
    }
  }
}
