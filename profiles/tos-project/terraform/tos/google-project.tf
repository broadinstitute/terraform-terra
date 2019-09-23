resource "google_project" "project" {
  name                  = "${var.google_project}"
  project_id            = "${var.google_project}"
  billing_account       = "${var.google_billing_account_id}"
  folder_id             = "${var.google_folder_id}"
  auto_create_network   = false
}

