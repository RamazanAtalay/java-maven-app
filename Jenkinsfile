pipeline {
    agent any
    stages {
        stage('1:Incrementing Version'){
            steps {
                script {
                    echo 'This is the incrementing the app version step'
                }
            }
        }
        stage("2:Building File") {
            steps{
                script{
                    echo "This is the building the file for the app step"
                }
            }
        }
        stage("3:Building Image") {
            steps {
                script {
                    echo "This is the building the docker image tagged"                
                }
            }
        }
        stage("4:Deploying Image") {
            steps {
                script {
                    echo "This is the deploying the tagged to docker hub"                   
                }
            }
        }
        stage("5:Running App") {
            steps {
                script {
                    echo "This is the deploying the tagged to docker hub"                   
                }
            }
        }
        stage("6:Committing Version") {
            steps {
                script {
                    echo "This is the commit to update the POM.xml file by in the git repository"                    
                }
            }
        }
    }
}
