pipeline {
    agent any
    stages {
        stage('1:Incrementing'){
            steps {
                script {
                    echo 'This is the incrementing the app version step'                    
                }
            }
        }
        stage("2:Packaging") {
            steps{
                script{
                    echo "This is the building the file for the app step"       
                }
            }
        }
        stage("3:Building") {
            steps {
                script {
                    echo "This is the building the docker image tagged by"                  
                }
            }
        }
        stage("4:Deploying") {
            steps {
                script {
                    echo "This is the deploying the tagged to docker hub"
                   
                }
            }
        }
        stage("5:Provisioning") {
            steps {
                script {
                    echo "This is the EC2 provisioning step for tagged"
                }
            }
        }
        stage("6:Running") {
            steps {
                script {
                   echo "This is waiting time for EC2 server to fully initialize"
                }
            }
        }
        stage("7:Committing") {
            steps {
                script {
                    echo "This is the commit to update the POM.xml file by in the git repository"
                    
                }
            }
        }
    }
}
