pipeline {
    agent any 
    
    tools{
        jdk 'jdk17'
        maven 'maven'
    }
    environment {
        SCANNER_HOME=tool 'sonarQube'
    }
    
    stages{
        
        stage("Git Checkout"){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/kparunsagar/devsecops.git'
            }
        }
        stage('Scan') {
            steps {
                withSonarQubeEnv(installationName: 'sonarQube') { 
                  sh './mvnw org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
                }
            }
        }
            
        stage("Compile"){
            steps{
                sh "mvn clean compile"
            }
        }


         stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }
        
    }
}
