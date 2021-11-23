pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    tools {
        maven 'Maven'
    }
    stages {
        stage('1: Incrementing Version'){
            steps {
                script {
                    echo '\033[35m 1: This is the incrementing the app version step \033[0m'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                         versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
//                    env.IMAGE_NAME = "java-maven-app-${version}-${BUILD_NUMBER}"
                   env.IMAGE_NAME = "$version-$BUILD_NUMBER"
//                    env.IMAGE_NAME = "java-maven-app-${version}"
//                    env.IMAGE_NAME = "$version"
                    echo "IMAGE_NAME:${IMAGE_NAME}, version:${version}, and BUILD_NUMBER:${BUILD_NUMBER}"
                }
            }
        }
        stage("2: Building File") {
            steps{
                script{
                    echo "\033[35m 2: This is the building the .jar file for the app step \033[0m"
                    sh 'mvn clean package'
                }
            }
        }
        stage("3: Building Image") {
            steps {
                script {
                    echo "\033[35m This is the building the docker image tagged by ${IMAGE_NAME} \033[0m"
                    sh "docker build -t ramazanatalay/my-repo:${IMAGE_NAME} ."
                }
            }
        }
        stage("4: Deploying Image") {
            steps {
                script {
                    echo "\033[35m 4: This is the deploying the tagged ${IMAGE_NAME} to docker hub \033[0m"
                    withCredentials([usernamePassword(credentialsId: 'dockerHub',
                            passwordVariable: 'PASS',
                            usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ramazanatalay/my-repo:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("5: Running App") {
            steps {
                script {
                    echo "\033[35m 5: This is the deploying the tagged ${IMAGE_NAME} to docker hub \033[0m"

                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
//                    def dockerComposeCmd = "docker-compose -f docker-compose.yml up --detach"
                    sshagent(['ec2-server-NVirginia-key']) {
                        sh "scp server-cmds.sh ec2-user@3.85.118.21:/home/ec2-user"
                        sh "scp docker-compose.yml ec2-user@3.85.118.21:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.85.118.21 ${shellCmd}"
                    }
                }
            }
        }
        stage("6: Commit the Version Update") {
            steps {
                script {
                    echo "\033[36m 6: This is the commit to update the POM.xml file by ${IMAGE_NAME} in the git repository\033[0m"
//                    withCredentials([usernamePassword(credentialsId: 'Jenkins-GitHub-ratalay',
//                            usernameVariable: 'GITHUB_APP',
//                            passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {
//                                withCredentials(
//                                        [string(credentialsId: 'git-email', variable: 'GIT_COMMITTER_EMAIL'),
//                                         string(credentialsId: 'git-account', variable: 'GIT_COMMITTER_ACCOUNT'),
//                                         string(credentialsId: 'git-name', variable: 'GIT_COMMITTER_NAME'),
//                                         string(credentialsId: 'github-token', variable: 'GITHUB_API_TOKEN')]) {
//                                    // Configure the user
//                                    sh 'git config user.email "${GIT_COMMITTER_EMAIL}"'
//                                    sh 'git config user.name "${GIT_COMMITTER_NAME}"'
//                        sh "git remote rm origin"
//                        sh 'git remote add origin https://${GITHUB_ACCESS_TOKEN}@github.com/ratalay35/java-maven-app.git > /dev/null 2>&1'
//                        sh "git commit -am 'Commit message'"
//                        sh 'git push origin https://${GITHUB_ACCESS_TOKEN}@github.com/ratalay35/java-maven-app.git:jenkins-jobs > /dev/null 2>&1'

//                        sh 'git config --global user.email "jenkins@gmail.com"'
//                        sh 'git config --global user.name "Ramazan Atalay"'
//                        sh 'git status'
//                        sh 'git branch'
//                        sh 'git config --list'
//
//                        sh 'git add -f .'
//                        sh 'git commit -m "ci: version bump"'
//                        sh 'git remote set-url origin https://${GITHUB_ACCESS_TOKEN}@github.com/ratalay35/java-maven-app.git'
////                        sh 'git push origin HEAD:jenkins-jobs'
//                        sh 'git push -fq 'https://${GITHUB_ACCESS_TOKEN}@github.com/ratalay35/java-maven-app.git''
                        // sh 'git push -u -fq origin HEAD:jenkins-jobs'
//                    https://github.com/ratalay35/java-maven-app.git
                        //                       sh "git push -fq https://ratalay35:${GITHUB_ACCESS_TOKEN}@github.com/ratalay35/java-maven-app.git HEAD:jenkins-jobs"
//                    }
                }
            }
        }
    }
}
