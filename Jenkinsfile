pipeline {
  agent { label 'podman-agent' } // ensure you create an agent with this label
  environment {
    REGISTRY = 'localhost:5000'
    IMAGE = "${REGISTRY}/myflask"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Install deps & Test') {
      steps {
        sh 'python3 -m pip install --user -r requirements.txt'
        sh 'python3 -m pytest -q'
      }
    }
    stage('Build Image') {
      steps {
        sh "podman build -t ${IMAGE}:${BUILD_NUMBER} ."
      }
    }
    stage('Push Image') {
      steps {
        // For local registry without auth; if auth needed, configure credentials
        sh "podman push ${IMAGE}:${BUILD_NUMBER}"
      }
    }
    stage('Deploy Staging') {
      steps {
        sh '''
        # stop old container if exists
        podman ps --filter "name=myflask-staging" --format "{{.ID}}" | xargs -r podman stop
        podman ps -a --filter "name=myflask-staging" --format "{{.ID}}" | xargs -r podman rm
        podman run -d --name myflask-staging -p 5001:5000 ${IMAGE}:${BUILD_NUMBER}
        '''
      }
    }
  }
  post {
    always { sh 'echo Build finished: ${BUILD_STATUS}' }
  }
}
