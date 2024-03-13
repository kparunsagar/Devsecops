pipeline {
    agent any 
    
    tools{
        jdk 'jdk7'
        maven 'maven'
    }
    
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
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

        stage('SonarQube Analysis') {
            steps {
                script {
                    def mvnHome = tool 'maven'
                    withSonarQubeEnv() {
                    bat "${mvnHome}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=sts"
                    }
                }
            }
        }
        
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./ --format HTML ', odcInstallation: 'Dependency-check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
         stage("Build"){
            steps{
                sh " mvn clean install"
            }
        }
        
    }
}
