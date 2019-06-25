provider vault {}

# this token will get saved in the state file, which is why a low-scope, time-limited token (and not the user's token) is appropriate.
resource "vault_generic_secret" "database-credentials" {
  path = "secret/dsde/firecloud/ephemeral/${var.environment}/thurloe/secrets/app_sql_user"

  data_json = <<EOT
{
  "username": "${var.cloudsql_app_username}",
  "password": "${var.cloudsql_app_password}"
}
EOT
}
