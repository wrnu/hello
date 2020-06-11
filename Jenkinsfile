def branchName = currentBuild.projectName

def notifySlack(Map attrs) {
    String repoName = env.JOB_NAME.split('/')[0]
    String buildUrl = "https://jenkins.usc1a.appno.co/job/${repoName}/job/${env.BRANCH_NAME}/${env.BUILD_NUMBER}/"
    slackSend(
        channel: "#tcl-aem-dev",
        color: attrs.color,
        message: "*${attrs.message}: <${buildUrl}>*",
        token: env.SLACK_TOKEN
    )
}

pipeline {
    agent {
        kubernetes {
            defaultContainer 'slave'
                  yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  containers:
  - name: slave
    image: gcr.io/devops-test-267218/slave:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
"""           
        }
    }

    environment {
        SLACK_TOKEN = credentials('slack-token')
    }

    options {
        ansiColor('xterm')
        disableConcurrentBuilds()
    }

    triggers {
        bitbucketPush()
    }

    stages {
        stage('Build') {
            when {
                anyOf { 
                    branch 'dev';
                    branch 'stage';
                    branch 'master';
                }
            }

            steps {
                sh """
                    VERSION=${env.BUILD_NUMBER} make release  
                """
            }
        }
    }
    
    post {
        success {
            notifySlack(
                color: '#00FF00', message: "Build successful"
            )
        }
        failure {
            notifySlack(
                color: '#FF0000', message: "Build failed"
            )
        }
    }
}

