resource "vault_generic_secret" "endpoint" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/endpoint"

  data_json = <<EOT
{
  "endpoint": "${google_cloudfunctions_function.function.https_trigger_url}"
}
EOT
}
