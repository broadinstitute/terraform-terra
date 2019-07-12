resource "google_service_account" "gsuite_admin" {
  provider = "google.gsuite-admin-sa"
  account_id   = "${var.gsuite_admin_sa_name}"
}

resource "google_service_account_key" "app_account_key" {
  service_account_id = "${google_service_account.gsuite_admin.name}"
}

resource "vault_generic_secret" "app_account_key" {
  path = "${var.gsuite_admin_sa_key_vault_path}"
  data_json = "${base64decode(google_service_account_key.app_account_key.private_key)}"
}
