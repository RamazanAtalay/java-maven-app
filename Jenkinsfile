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
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
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
                    def ec2Instance = "ec2-user@3.85.118.21"
                    sshagent(['ec2-server-NVirginia-key']) {
                        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp docker-compose.yml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
        stage("6: Committing Version Update") {
            steps {
                script {
                    echo "\033[36m 6: This is the commit to update the POM.xml file by ${IMAGE_NAME} in the git repository\033[0m"
                    withCredentials([usernamePassword(credentialsId: 'GitHub',
                            usernameVariable: 'GITHUB_APP',
                            passwordVariable: 'GITHUB_ACCESS_TOKEN')]) {

                        sh 'git config --global user.email "you@example.com"'
                        sh 'git config --global user.name "Your Name"'

                        sh "git remote set-url origin https://${GITHUB_ACCESS_TOKEN}@github.com/ramazan-atalay/java-maven-app.git > /dev/null 2>&1"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-deploy-ec2-from-jenkins-pipeline'
                    }
                }
            }
        }
    }
}
