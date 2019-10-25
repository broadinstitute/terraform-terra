resource "google_project" "singlecellportal-mongo" {
  name                  = "${var.google_project}"
  project_id            = "${var.google_project}"
  billing_account       = "${var.google_billing_account_id}"
  auto_create_network   = false
}