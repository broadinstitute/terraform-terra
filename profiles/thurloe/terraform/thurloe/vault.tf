provider vault {}

resource "vault_generic_secret" "database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/app_sql_user"

  data_json = <<EOT
{
  "username": "${var.cloudsql_app_username}",
  "password": "${var.cloudsql_app_password}"
}
EOT
}
