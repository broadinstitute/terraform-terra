resource "vault_generic_secret" "url" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/url"

  data_json = <<EOT
{
  "url": "${var.owner}-${var.environment}-${var.service}-dot-${data.google_client_config.app-engine.project}.appspot.com"
}
EOT
}
