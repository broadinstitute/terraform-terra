provider vault {}

resource "vault_generic_secret" "database-credentials" {
  path = "secret/dsde/firecloud/ephemeral/${var.environment}/thurloe/secrets/app_sql_user"

  data_json = <<EOT
{
  "username": "${var.cloudsql_app_username}",
  "password": "${var.cloudsql_app_password}"
}
EOT
}
