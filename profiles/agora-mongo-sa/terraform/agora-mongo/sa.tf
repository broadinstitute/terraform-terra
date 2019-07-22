resource "google_service_account" "app_config" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app_config" {
  project = "${var.google_project}"
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.app_config.email}"
}
