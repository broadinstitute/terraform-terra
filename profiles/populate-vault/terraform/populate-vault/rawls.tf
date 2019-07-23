resource "vault_generic_secret" "martha_url_replaceme" {
  path = "${var.vault_path_prefix}/martha/secrets/url"
  data_json = <<EOT
{
  "url": "https://us-central1-broad-dsde-tmp.cloudfunctions.net"
}
EOT
}

resource "vault_generic_secret" "cromwell_url_replaceme" {
  path = "${var.vault_path_prefix}/cromwell/secrets/hostnames"
  data_json = <<EOT
{
  "cromwell1": "cromwell1.not.a.real.domain.org",
  "cromwell2": "cromwell2.not.a.real.domain.org"
}
EOT
}
