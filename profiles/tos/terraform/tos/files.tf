data "google_client_config" "app-engine" {
}

resource "local_file" "get_repo" {
  content = <<EOT
#!/usr/bin/env bash
set -eo pipefail
rm -rf terraform-function-working
mkdir -p terraform-function-working
cd terraform-function-working
git clone https://${var.function_git_hostname}/${var.function_git_path_prefix}/${var.function_repo_name}.git
cd ${var.function_repo_name}
git checkout ${var.function_git_refspec}
EOT
  filename = "${path.module}/get_repo.sh"
}

resource "local_file" "deploy_prep" {
  content = <<EOT
#!/usr/bin/env bash
set -eo pipefail
cd terraform-function-working/${var.function_repo_name}
${var.function_repo_setup_script}
EOT
  filename = "${path.module}/setup_repo.sh"
}

resource "local_file" "function_upload" {
  content = <<EOT
#!/usr/bin/env bash
set -eo pipefail
gcloud auth activate-service-account --key-file=${path.module}/${var.function_deployment_service_account_filename}
cd terraform-function-working/${var.function_repo_name}/
gcloud datastore --project="${var.google_project}" indexes create datastore/index.yaml
cd ${var.function_path_in_repo}
cp ../../../config.js .
zip ${var.function_archive_bucket_filename} *
gsutil cp "./${var.function_archive_bucket_filename}" "gs://${google_storage_bucket.function-deploy.name}/${var.function_archive_bucket_path}/${var.function_archive_bucket_filename}"
EOT
  filename = "${path.module}/function_upload.sh"
}
