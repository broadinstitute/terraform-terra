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

# CI access
resource "google_service_account" "ci" {
  account_id   = "${var.owner}-ci-sa"
  project      = "${var.google_project}"
  display_name = "${var.owner}-ci-sa"
}

resource "google_project_iam_member" "ci" {
  count   = "${length(var.ci_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.ci_sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.ci.email}"
}

resource "google_service_account_key" "ci_account_key" {
  service_account_id = "${google_service_account.ci.name}"
}
