resource "google_service_account" "app_config" {
  account_id   = "${var.owner}-${var.service}"
  project      = "${var.google_project}"
}

resource "google_project_iam_member" "app" {
  count   = "${length(var.app_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.app_sa_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app_config.email}"
}

data "google_service_account" "orch_sa" {
  account_id  = "firecloud-orchestration"
  project = "${var.main_env_project}"
}

resource "google_project_iam_member" "orch" {
  count   = "${length(var.orch_sa_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.orch_sa_roles, count.index)}"
  member  = "serviceAccount:${data.google_service_account.orch_sa.email}"
}
