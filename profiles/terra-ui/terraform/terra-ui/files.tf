resource "local_file" "app_yaml" {
  content = <<EOT
runtime: python37
service: "${var.owner}-${var.environment}-${var.service}"
automatic_scaling:
  min_instances: 1
  max_instances: 100
  min_idle_instances: 1
entrypoint: gunicorn -b :$PORT main:app --worker-class sanic.worker.GunicornWorker
EOT
  filename = "${path.module}/app.yaml"
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
git clone https://github.com/DataBiosphere/calhoun.git
cd calhoun
git checkout ${var.calhoun_git_commit}
cp ${local_file.app_yaml.filename} .
cp ${local_file.config_py.filename} .
gcloud app deploy --bucket=gs://${google_storage_bucket.app-bucket.name} --project=${data.google_client_config.app-engine.project}
EOT
  filename = "${path.module}/deploy.sh"
}


resource "local_file" "config_py" {
  content = <<EOT
SAM_ROOT = "${var.sam_address}"
EOT
  filename = "${path.module}/config.py"
}
