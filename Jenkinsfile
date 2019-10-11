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
    // Until we get the correct vault policy on all nodes
    label 'node220'
  }
  stages {
    stage ('init submodules'){
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
    stage ('test'){
      steps {
        script {
          sh "docker run -it --rm -e VAULT_TOKEN=\$(cat /etc/dsde-read-ephemeral-write) -e VAULT_ADDR=https://clotho.broadinstitute.org:8200 --cap-add IPC_LOCK vault:1.0.0 vault token create -policy=dsde-read-ephemeral-write"
        }
      }
    }
    stage ('deploy'){
      steps {
        script {
          sh "./dsp-k8s-deploy/application-deploy.sh -j ${params.environment}.json -p ${params.profile} -v /etc/dsde-read-ephemeral-write"
        }
      }
    }
  }
}
