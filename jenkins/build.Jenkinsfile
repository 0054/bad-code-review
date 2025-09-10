#!/usr/bin/env groovy

currentBuild.description = "Deploying"

def repo = 'git@github.com:0054/bad-code-review.git'
def git_ssh_creds = [credentials: ["github_key"]]
def credentials = [
    aws(credentialsId: 'aws_creds', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'),
]


pipeline {
    agent {
        label any
    }
    options {
        ansiColor('xterm')
    }
    parameters {
        gitParameter(
            branch: '',
            branchFilter: 'origin/(.*)',
            defaultValue: 'develop',
            name: 'BRANCH',
            quickFilterEnabled: true,
            selectedValue: 'DEFAULT',
            sortMode: 'DESCENDING_SMART',
            tagFilter: '*',
            type: 'PT_BRANCH_TAG',
            description: 'Source code branch or tag to checkout to.',
            useRepository: "${repo}",
        )
        stringParameter(
                name: 'IMAGE_TAG',
                defaultValue: 'latest',
        )

    }

    stages {
        stage('Checkout'){
            steps{
                checkout([$class: 'GitSCM',
                        branches: [[name: "${env.BRANCH}"]],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        gitTool: 'Default',
                        submoduleCfg: [],
                        userRemoteConfigs: [[credentialsId: 'github_key', url: repo]]
                        ])
            }
        }
        stage('building') {
            steps {
                script {
                    withCredentials([credentials]) {
                        sshagent(git_ssh_creds){
                            sh 'TAG=$IMAGE_TAG'
                            sh 'make build'
                        }
                    }
                }
            }
        }
        stage('test') {
            steps {
                script {
                    sh 'make test'
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    withCredentials([credentials]) {
                        sh '''
                            docker push $(make print-image-name):$(IMAGE_TAG)
                        '''
                    }
                }
            }
        }
    }
    post {
        success {
            cleanWs()
            script { currentBuild.description = "👌 Successfully built" }
        }
        failure {
            cleanWs()
        }
    }
}