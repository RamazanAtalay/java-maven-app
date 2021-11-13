pipeline {
    agent none
    tools {
        maven 'Maven'
    }
    stages {
        stage('test') {
            steps {
                script {
                    echo "Building the application..."
                    echo "Executing pipeline for the branch $BRANCH_NAME"
                   // sh 'mvn package'
                }
            }
        }
        stage('build') {
            when {
                expression{
                      BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                    echo "Building the docker image..."
                    // withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')])
                      //       sh 'docker build -t ratalay35/my-repo:jma-2.2 .'
                        //     sh "echo $PASS | docker login -u $USER --password-stdin"
                          //   sh 'docker push ratalay35/my-repo:jma-2.2'
                     }
                }                                                                                          
            }
        }
        stage('deploy') {
             when {
                   expression{
                        BRANCH_NAME == 'master'
                   }
             }
            steps {
                script {
                    echo "Deploying the application..."
                }
            }
        }
    }
}
