resource "google_service_account" "app_config" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app_config" {
  project = "${var.google_project}"
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.app_config.email}"
}

resource "google_project_iam_member" "app_sql_binding" {
  project = "${var.google_project}"
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.app_config.email}"
}

resource "google_project_iam_member" "app_pubsub_binding" {
  project = "${var.google_project}"
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.app_config.email}"
}

# Grant service account access to container registry
resource "google_storage_bucket_iam_member" "app_config" {
  bucket = "${var.gcr_bucket_name}"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.app_config.email}"
}

resource "google_service_account_key" "app_account_key" {
  service_account_id = "${google_service_account.app_config.name}"
}

provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}-account.json"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}
