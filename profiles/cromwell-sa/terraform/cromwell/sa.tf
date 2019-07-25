resource "google_service_account" "app" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app" {
  count   = "${length(var.app_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.app_sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app.email}"
}

# Grant service account access to container registry
resource "google_storage_bucket_iam_member" "app" {
  bucket = "${var.gcr_bucket_name}"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.app.email}"
}

resource "google_service_account_key" "app_account_key" {
  service_account_id = "${google_service_account.app.name}"
}

resource "vault_generic_secret" "app_account_key" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}-account.json"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}
