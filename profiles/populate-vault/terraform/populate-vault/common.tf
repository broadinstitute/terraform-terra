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

resource "vault_generic_secret" "bond_dummy_url" {
  path = "${var.vault_path_prefix}/bond/secrets/url"
  data_json = <<EOT
{
  "url": "https://${var.owner}-bond.appspot.com"
}
EOT
}

resource "vault_generic_secret" "martha_dummy_urls" {
  path = "${var.vault_path_prefix}/martha/secrets/urls"
  data_json = <<EOT
{
  "fileSummary": "https://us-central1-${var.google_project}.cloudfunctions.net/fileSummaryV1",
  "martha": "https://us-central1-${var.google_project}.cloudfunctions.net/martha_v1"
}
EOT
}

resource "vault_generic_secret" "shibboleth_dummy_url" {
  path = "${var.vault_path_prefix}/shibboleth/secrets/url"
  data_json = <<EOT
{
  "url": "http://mock-nih.dev.test.firecloud.org"
}
EOT
}
