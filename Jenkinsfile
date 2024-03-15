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
            
        stage("Compile"){
            steps{
                sh "mvn clean compile"
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
