resource "google_service_account" "app" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
  display_name = "${var.owner}-${var.service}"
}

resource "google_project_iam_member" "app" {
  count   = "${length(var.app_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.app_sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app.email}"
}

resource "google_project_iam_member" "app-deployment-manager" {
  count   = "${length(var.app_sa_roles)}"
  project = "${var.deployment_manager_google_project}"
  role    = "${element(var.app_sa_deployment_manager_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app.email}"
}

resource "google_project_iam_member" "billing-deployment-manager" {
  count   = "${length(var.billing_accounts)}"
  project = "${var.deployment_manager_google_project}"
  role    = "roles/deploymentmanager.editor"
  member  = "user:${element(var.billing_accounts, count.index)}"
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

provider "vault" {}

resource "vault_generic_secret" "app_account_key" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}-account.json"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}

resource "google_service_account" "billingprobe" {
  account_id   = "${var.owner}-billingprobe"
  project      = "${var.deployment_manager_google_project}"
  display_name = "${var.owner}-billingprobe"
}

resource "google_service_account_key" "billingprobe_account_key" {
  service_account_id = "${google_service_account.app.name}"
}

resource "vault_generic_secret" "billingprobe_account_key" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}-billingprobe-account.json"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}
