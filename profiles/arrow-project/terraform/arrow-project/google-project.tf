resource "google_project" "arrow-project" {
  name                  = "${var.google_project_id}"
  project_id            = "${var.google_project_id}"
  billing_account       = "${var.google_billing_account_id}"
  folder_id             = "${var.google_folder_id}"
  auto_create_network   = false
}

