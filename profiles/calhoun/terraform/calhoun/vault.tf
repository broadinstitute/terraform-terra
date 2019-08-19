resource "vault_generic_secret" "endpoint" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/endpoint"

  data_json = <<EOT
{
  "endpoint": "${var.owner}-${var.environment}-${var.service}-dot-${data.google_client_config.app-engine.project}.appspot.com"
}
EOT
}
