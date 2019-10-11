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
        // GIT submodule recursive checkout
        checkout scm: [
          $class: 'GitSCM',
          branches: scm.branches,
          doGenerateSubmoduleConfigurations: false,
          extensions: [[
            $class: 'SubmoduleOption',
            disableSubmodules: false,
            parentCredentials: true,
            recursiveSubmodules: true,
            reference: '',
            trackingSubmodules: false
          ]],
          submoduleCfg: [],
          userRemoteConfigs: scm.userRemoteConfigs
        ]
      }
    }
    stage ('deploy'){
      steps {
        script {
          sh "./dsp-k8s-deploy/application-deploy.sh -j ${params.environment}.json -p ${params.profile} -v /etc/vault-token-dsde"
        }
      }
    }
  }
}
