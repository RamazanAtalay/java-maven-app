#!/usr/bin/env groovy

def gv

pipeline {
    agent any
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage("Build Jar") {
            steps {
                script {
                    echo "Building Jar File"
                    gv.buildJar()
                }
            }
        }
        stage("Build Image") {
            steps {
                script {
                    echo "Building Image"
                    gv.buildImage()
                }
            }
        }
        stage("Deploy") {
            steps {
                script {
                    echo "Deploying the Image"
                    gv.deployApp()
                }
            }
        }
    }
}