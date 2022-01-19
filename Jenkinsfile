#!/usr/bin/env groovy
pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    tools {
        maven 'Maven'
        terraform 'Terraform'
    }
    stages {
        stage('1:Incrementing'){
            steps {
                script {
                    echo '\033[34m1:This is the incrementing the app version step \033[0m'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                         versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "java-maven-app-${version}"
                    echo "IMAGE_NAME:${IMAGE_NAME}, version:${version}, and BUILD_NUMBER:${BUILD_NUMBER}"
                }
            }
        }
        stage("2:Packaging") {
            steps{
                script{
                    echo "\033[34m2:This is the building the ${IMAGE_NAME}.jar file for the app step \033[0m"
                    sh 'mvn clean package'
                }
            }
        }
        stage("3:Building") {
            steps {
                script {
                    echo "\033[34m3:This is the building the docker image tagged by ${IMAGE_NAME} \033[0m"
                    sh "docker build -t ramazanatalay/my-repo:${IMAGE_NAME} ."
                }
            }
        }
        stage("4:Deploying") {
            steps {
                script {
                    echo "\033[34m4:This is the deploying the tagged ${IMAGE_NAME} to docker hub \033[0m"
                    withCredentials([usernamePassword(credentialsId: 'dockerHub',
                            passwordVariable: 'DOCKER_CREDS_PASSWORD',
                            usernameVariable: 'DOCKER_CREDS_USER')]) {
                        sh "echo $DOCKER_CREDS_PASSWORD | docker login -u $DOCKER_CREDS_USER --password-stdin"
                        sh "docker push ramazanatalay/my-repo:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("5:Provisioning") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script {
                echo "\033[34m4:This is the EC2 provisioning step for tagged ${IMAGE_NAME} \033[0m"
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output ec2_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        stage("6:Running") {
            environment {
                DOCKER_CREDS = credentials('dockerHub')
            }
            steps {
                script {
                   echo "waiting for EC2 server to initialize" 
                   sleep(time: 90, unit: "SECONDS") 

                   echo 'deploying docker image to EC2...'
                   echo "${EC2_PUBLIC_IP}"

                   def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
                   // credentials function gives read/writes attributes  with USR and PSW prefixes
                   def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                   sshagent(['server-ssh-key']) {
                       sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                       sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                       sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                   }
                }
            }
        }
        stage("7:Committing") {
            steps {
                script {
                    echo "\033[34m6:This is the commit to update the POM.xml file by ${IMAGE_NAME} in the git repository\033[0m"
                    withCredentials([usernamePassword(credentialsId: 'GitHub',
                            usernameVariable: 'GITHUB_APP',
                            passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {

                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh "git remote set-url origin https://${GITHUB_ACCESS_TOKEN}@github.com/ramazanatalay/java-maven-app.git > /dev/null 2>&1"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-ec2-terraform'
                    }
                }
            }
        }
    }
}
