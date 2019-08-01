resource "vault_generic_secret" "martha_url_replaceme" {
  path = "${var.vault_path_prefix}/martha/secrets/url"
  data_json = <<EOT
{
  "url": "https://us-central1-broad-dsde-tmp.cloudfunctions.net"
}
EOT
}
