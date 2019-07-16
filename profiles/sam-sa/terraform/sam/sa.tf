# Application service account
resource "google_service_account" "app" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app" {
  project = "${var.google_project}"
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.app.email}"
}

resource "google_project_iam_member" "app_pubsub_binding" {
  project = "${var.google_project}"
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.app.email}"
}

resource "google_project_iam_member" "app_owner" {
  project = "${var.google_project}"
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.app.email}"
}

# Application Firestore service account
resource "google_service_account" "firestore" {
  account_id   = "${var.owner}-${var.service}-firestore"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "firestore" {
  project = "${var.google_project}"
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.firestore.email}"
}

# Admin SDK service accounts
resource "google_service_account" "directory_sa_group" {
  count        = "${var.num_directory_sas}"
  account_id   = "${var.owner}-${var.service}-directory-sa-${count.index}"
  project      = "${var.google_project}"
  display_name = "${var.owner}-${var.service}-directory-sa-${count.index}"
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

resource "google_service_account_key" "app_firestore_account_key" {
  service_account_id = "${google_service_account.firestore.name}"
}

resource "google_service_account_key" "directory_sa_keys" {
  count        = "${var.num_directory_sas}"
  service_account_id = "${element(google_service_account.directory_sa_group.*.name, count.index)}"
}

provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}-account.json"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}

resource "vault_generic_secret" "app_firestore_account_key" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}-firestore-account.json"
  data_json = "${base64decode(google_service_account_key.app_firestore_account_key.private_key)}"
}

resource "vault_generic_secret" "directory_sa_keys" {
  count = "${var.num_directory_sas}"
  path = "${var.vault_path_prefix}/${var.service}/service_accounts/service_account_${count.index}"
  data_json = "${base64decode(element(google_service_account_key.directory_sa_keys.*.private_key, count.index))}"
}
