resource "google_service_account" "fc_dev" {
  account_id = "${var.fc_dev_sa_name}"
  project = "${var.fc_dev_sa_project}"
}

resource "google_organization_iam_binding" "fc_dev_org_binding" {
  count   = "${length(var.fc_dev_sa_org_roles)}"
  org_id = "${var.fc_test_org_id}"
  role    = "${element(var.fc_dev_sa_org_roles, count.index)}"
  members = [
    "serviceAccount:${google_service_account.fc_dev.email}"
  ]
}
