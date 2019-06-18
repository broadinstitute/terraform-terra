# Create configuration bucket
resource "google_service_account" "app_config" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
}
