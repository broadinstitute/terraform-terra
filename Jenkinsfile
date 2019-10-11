pipeline {
  parameters {
    string(
      name: 'environment',
      description: 'Ephemeral environment to target',
      defaultValue: 'broad-wb-malkov',
      trim: true
    )
    string(
      name: 'profile',
      description: 'Name of profile to deploy',
      trim: true
    )
  }
  agent {
    label 'docker'
  }
  stages {
    stage ('initialize'){
      steps {
        script {
          sh "git submodule init && git submodule update"
        }
      }
    }
    stage('deploy'){
      steps {
        script {
          sh "./dsp-k8s-deploy/application-deploy.sh -j $environment.json -p $profile"
        }
      }
    }
  }
}
