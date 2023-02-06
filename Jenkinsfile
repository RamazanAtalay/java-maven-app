pipeline {
    agent any
    environment {
        tag = sh(returnStdout: true, script: "git rev-parse --short=10 HEAD").trim()
    }

    stages {
        stage('Build core image') {
            steps {
                // TODO: proper tagging
                sh "docker build -t ramazanatalay/my-repo:${tag} ."
                withCredentials([usernamePassword(credentialsId: 'common-dockerhub-up', usernameVariable: 'HUB_USER', passwordVariable: 'HUB_PASS')]) {
                    sh "docker login -u ${HUB_USER} -p ${HUB_PASS} && docker push ramazanatalay/my-repo:${tag}"
                }
            }
        }
        stage('Build core comment image') {
            steps {
                // TODO: proper tagging
                sh "docker build -t ramazanatalay/my-repo:${tag} ."
                withCredentials([usernamePassword(credentialsId: 'common-dockerhub-up', usernameVariable: 'HUB_USER', passwordVariable: 'HUB_PASS')]) {
                    sh "docker login -u ${HUB_USER} -p ${HUB_PASS} && docker push ramazanatalay/my-repo:${tag}"
                }
            }
        }
    }
}
