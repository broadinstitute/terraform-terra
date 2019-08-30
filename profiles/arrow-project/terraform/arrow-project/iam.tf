resource "google_project_iam_member" "project-editors" {
  count   = "${length(var.project_editors)}"
  project = "${var.google_project}"
  role    = "roles/editor"
  member  = "${var.project_editors[count.index]}"
}

resource "google_project_iam_member" "project-owners" {
  count   = "${length(var.project_owners)}"
  project = "${var.google_project}"
  role    = "roles/owner"
  member  = "${var.project_owners[count.index]}"
}
# Application service account
resource "google_service_account" "terraform" {
  account_id   = "${var.google_project}-terraform"
  project      = "${var.google_project}"
  display_name = "${var.google_project}-terraform"
}

resource "google_project_iam_member" "terraform-account" {
  project = "${var.google_project}"
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_service_account_key" "terraform_account_key" {
  service_account_id = "${google_service_account.terraform.name}"
}

resource "vault_generic_secret" "terraform_account_key" {
  path = "${var.terraform_sa_key_path}"
  data_json = "${base64decode(google_service_account_key.terraform_account_key.private_key)}"
}
