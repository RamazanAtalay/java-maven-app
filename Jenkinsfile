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
                    sh "docker build -t ramazanatalay/my-repo:${IMAGE_NAME} ."
                }
            }
        }
        stage("Deploying Image") {
            steps {
                script {
                    echo "\033[35m This is the deploying the tagged ${IMAGE_NAME} to docker hub \033[0m"
                    withCredentials([usernamePassword(credentialsId: 'dockerHub',
                            passwordVariable: 'PASS',
                            usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ramazanatalay/my-repo:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("Commit Version Update") {
            steps {
                script {
                    echo "\033[36m This is the commit to update the POM.xml file by ${IMAGE_NAME} in the git repository\033[0m"
//                    withCredentials([usernamePassword(credentialsId: 'Jenkins-GitHub-ratalay',
//                            usernameVariable: 'GITHUB_APP',
//                            passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {


                                GITHUB_ACCESS_TOKEN: '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'



                        sh 'git config --global user.email "jenkins@gmail.com"'
                        sh 'git config --global user.name "Ramazan Atalay"'
                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'
                        sh 'git remote add origin https://${credentialsId}@github.com/ratalay35/java-maven-app.git'
                        sh 'git add -f .'
                        sh 'git commit -m "ci: version bump"'
//                        sh 'git push origin HEAD:jenkins-jobs'
//                        sh "git push -fq 'https://${credentialsId}@github.com/ratalay35/java-maven-app.git'"
                        sh 'git push -fq origin HEAD:jenkins-jobs'

 //                       sh "git push -fq https://ratalay35:${GITHUB_ACCESS_TOKEN}@github.com/ratalay35/java-maven-app.git HEAD:jenkins-jobs"
//                    }
                }
            }
        }
    }
}