# CloudSQL access
resource "google_service_account" "cloudsql" {
  account_id   = "${var.owner}-db-sa"
  project      = "${var.google_project}"
  display_name = "${var.owner}-db-sa"
}

resource "google_project_iam_member" "cloudsql" {
  project = "${var.google_project}"
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudsql.email}"
}

resource "google_service_account_key" "cloudsql_account_key" {
  service_account_id = "${google_service_account.cloudsql.name}"
}
