provider vault {}

resource "vault_generic_secret" "credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets"

  data_json = <<EOT
{
  "dirmanagerpw": "${random_id.dirmanagerpw.hex}",
  "keystorepin": "${random_id.keystorepin.hex}"
}
EOT
}