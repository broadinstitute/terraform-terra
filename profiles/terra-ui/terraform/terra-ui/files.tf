resource "local_file" "config_json" {
  content = <<EOT
{
  "agoraUrlRoot": "${var.agora_url}",
  "bondUrlRoot": "${var.bond_url}",
  "calhounUrlRoot": "${var.calhoun_url}",
  "dockstoreUrlRoot": "https://dockstore.org",
  "firecloudBucketRoot": "https://storage.googleapis.com/firecloud-alerts",
  "firecloudUrlRoot": "https://portal.firecloud.org",
  "googleClientId": "${var.google_client_id}",
  "isProd": ${var.is_prod},
  "jobManagerUrlRoot": "${var.job_manager_url}/jobs",
  "leoUrlRoot": "${var.leo_url}",
  "marthaUrlRoot": "${var.martha_url}",
  "orchestrationUrlRoot": "${var.orch_url}",
  "rawlsUrlRoot": "${var.rawls_url}",
  "rexUrlRoot": "${var.rex_url}",
  "samUrlRoot": "${var.sam_url}",
  "shibbolethUrlRoot": "${var.shibboleth_url}",
  "tCell": {
    "appId": "${var.tcell_api_id}",
    "apiKey": "${var.tcell_api_key}"
  },
  "tosUrlRoot": "${var.tos_url}"
}
EOT
  filename = "${path.module}/config.json"
}

data "google_client_config" "app-engine" {
  provider = "google.app-engine"
}

resource "local_file" "deploy_script" {
  content = <<EOT
#!/usr/bin/env bash
set -eo pipefail
gcloud auth activate-service-account --key-file=./app-engine.sa.json
rm -rf terraform-gae-working
mkdir -p terraform-gae-working
cd terraform-gae-working
git clone https://github.com/DataBiosphere/terra-ui.git
cd terra-ui
git checkout ${var.terra_git_commit}
docker run -v $PWD:/app -v $PWD/.npm:/.npm -v $PWD/.config:/.config -w /app node:10 sh -c 'npx npm@6.10 ci && npx npm@6.10 run build'
cp ${abspath(local_file.config_json.filename)} ./config/config.json
gcloud app deploy --bucket=gs://${google_storage_bucket.app-bucket.name} --project=${data.google_client_config.app-engine.project}
EOT
  filename = "${path.module}/deploy.sh"
}
