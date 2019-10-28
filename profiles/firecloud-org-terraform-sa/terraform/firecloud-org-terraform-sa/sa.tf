resource "google_service_account" "app" {
  display_name   = "${var.owner}-terraform-sa"
  account_id   = "${var.owner}-terraform-sa"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app" {
  count   = "${length(var.app_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.app_sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app.email}"
}

resource "google_service_account_key" "app_account_key" {
  service_account_id = "${google_service_account.app.name}"
}


provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  path = var.sa_key_vault_path
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}
