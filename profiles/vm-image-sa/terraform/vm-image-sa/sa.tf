resource "google_service_account" "app_config" {
  account_id   = "${var.account_name}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app" {
  count   = "${length(var.sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app_config.email}"
}

resource "google_service_account_key" "app_account_key" {
  service_account_id = "${google_service_account.app_config.name}"
}

provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  path = "secret/dsde/firecloud/common/${var.account_name}-account.json"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}
