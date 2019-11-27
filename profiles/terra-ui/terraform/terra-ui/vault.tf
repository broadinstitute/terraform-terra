resource "vault_generic_secret" "url" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/url"

  data_json = <<EOT
{
  "url": "${data.google_client_config.app-engine.project}.appspot.com"
}
EOT
}
