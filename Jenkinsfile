pipeline {
    agent {label "docker-build-node"}
    
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        SCANNER_HOME=tool 'sonarQube'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        CI = true
        ARTIFACTORY_ACCESS_TOKEN = credentials('artifactory-access-token')
    }
    
    stages{
        
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/kparunsagar/devsecops.git'
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
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonarQube') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Petclinic '''
    
                }
            }
        }       
        stage ("Artifactory Publish"){
          steps {
            script{
              def server = Artifactory.server 'Artifactory'
              def rtMaven = Artifactory.newMavenBuild()
              //rtMaven.resolver server: server, releaseRepo: 'jenkinsdemo_repo', snapshotRepo: 'demopipeline'
              rtMaven.deployer server: server, releaseRepo: 'petclinic-petclinic-releases', snapshotRepo: 'petclinic-petclinic-snapshot'
              rtMaven.tool = 'maven'
                            
              def buildInfo = rtMaven.run pom: '$workspace/pom.xml', goals: 'clean install'
              rtMaven.deployer.deployArtifacts = true
              rtMaven.deployer.deployArtifacts buildInfo
              server.publishBuildInfo buildInfo
            }
          }
        }
         stage("Build"){
            steps{
                sh " mvn clean install"
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
        stage("Deploy To Tomcat"){
            steps{
                sh "sudo cp -r /var/lib/jenkins/workspace/devsecops1/target/petclinic.war /opt/apache-tomcat-9.0.87/webapps/ "
            }
        }
    }
}
