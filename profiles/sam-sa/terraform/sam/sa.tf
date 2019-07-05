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
resource "google_service_account" "sam_sa_0" {
  account_id   = "${var.owner}-${var.service}-0"
  project      = "${var.google_project}"
}
resource "google_service_account" "sam_sa_1" {
  account_id   = "${var.owner}-${var.service}-1"
  project      = "${var.google_project}"
}
resource "google_service_account" "sam_sa_2" {
  account_id   = "${var.owner}-${var.service}-2"
  project      = "${var.google_project}"
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

resource "google_service_account_key" "sam_sa_0_key" {
  service_account_id = "${google_service_account.firestore.name}"
}

resource "google_service_account_key" "sam_sa_1_key" {
  service_account_id = "${google_service_account.firestore.name}"
}

resource "google_service_account_key" "sam_sa_2_key" {
  service_account_id = "${google_service_account.firestore.name}"
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

resource "vault_generic_secret" "sam_sa_0_key" {
  path = "${var.vault_path_prefix}/${var.service}/service_accounts/service_account_0"
  data_json = "${base64decode(google_service_account_key.sam_sa_0_key.private_key)}"
}

resource "vault_generic_secret" "sam_sa_1_key" {
  path = "${var.vault_path_prefix}/${var.service}/service_accounts/service_account_1"
  data_json = "${base64decode(google_service_account_key.sam_sa_1_key.private_key)}"
}

resource "vault_generic_secret" "sam_sa_2_key" {
  path = "${var.vault_path_prefix}/${var.service}/service_accounts/service_account_2"
  data_json = "${base64decode(google_service_account_key.sam_sa_2_key.private_key)}"
}
