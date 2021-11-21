#!/usr/bin/env groovy

pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    tools {
        maven 'Maven'
    }
    stages {
        stage('Incrementing Version'){
            steps{
                script{
                    echo '\033[35m This is the incrementing the app version step \033[0m'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage("Building File") {
            steps {
                script {
                    echo "\033[35m This is the building the .jar file for the app step \033[0m"
                    sh 'mvn clean package'
                }
            }
        }
        stage("Building Image") {
            steps {
                script {
                    echo "\033[35m This is the building the docker image tagged by ${IMAGE_NAME} \033[0m"
//   /                 sh "docker build -t ramazanatalay/my-repo:${IMAGE_NAME} ."
                }
            }
        }
        stage("Deploying Image") {
            steps {
                script {
                    echo "\033[35m This is the deploying the tagged ${IMAGE_NAME} to docker hub \033[0m"
//                    withCredentials([usernamePassword(credentialsId: 'dockerHub',
//                            passwordVariable: 'PASS',
//                            usernameVariable: 'USER')]) {
//                        sh "echo $PASS | docker login -u $USER --password-stdin"
//                        sh "docker push ramazanatalay/my-repo:${IMAGE_NAME}"
//                    }
                }
            }
        }
        stage("Commit Version Update") {
            steps {
                script {
                    def dockerCmd= 'docker run -d -p 3080:3080 ramazanatalay/my-repo:1.1.8-33'
                    sshagent(['ec2-server-key']) {
                        sh"ssh -o StrictHostKeyChecking=no ec2-user@3.85.118.21 ${dockerCmd}"
                    }
                }
            }
        }
    }
}