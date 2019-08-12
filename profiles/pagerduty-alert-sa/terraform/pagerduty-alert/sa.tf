resource "google_service_account" "app" {
  display_name   = "${var.service}"
  account_id   = "${var.service}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app" {
  count   = "${length(var.app_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.app_sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app.email}"
}
