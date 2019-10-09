data "google_project" "google_project" {
  project_id = "${var.google_project}"
}

resource "vault_generic_secret" "google_project_id" {
  path = "${var.vault_path_prefix}/common/google_project_number"
  depends_on = [ "data.google_project.google_project" ]
  data_json = <<EOT
{
  "number": "${data.google_project.google_project.number}"
}
EOT
}
