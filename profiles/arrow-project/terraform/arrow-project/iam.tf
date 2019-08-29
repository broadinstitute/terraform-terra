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

