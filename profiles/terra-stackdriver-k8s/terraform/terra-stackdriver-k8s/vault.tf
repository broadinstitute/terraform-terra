resource "vault_generic_secret" "app-database-credentials" {
  path = "${var.vault_path_prefix}/${var.owner}/common/postgres/app_sql_user"

  data_json = <<EOT
{
  "username": "${var.cloudsql_app_username}",
  "password": "${random_id.user-password.hex}"
}
EOT
}

resource "vault_generic_secret" "root-database-credentials" {
  path = "${var.vault_path_prefix}/${var.owner}/common/postgres/root_sql_user"

  data_json = <<EOT
{
  "username": "root",
  "password": "${random_id.root-password.hex}"
}
EOT
}

resource "vault_generic_secret" "database-instance-name" {
  path = "${var.vault_path_prefix}/${var.owner}/common/postgres/instance"

  data_json = <<EOT
{
  "name": "${module.cloudsql.cloudsql-instance-name}"
}
EOT
}

resource "vault_generic_secret" "cloudsql_account_key" {
  path = "${var.vault_path_prefix}/${var.owner}/common/postgres/cloudsql-account.json"
  data_json = "${base64decode(google_service_account_key.cloudsql_account_key.private_key)}"
}

resource "vault_generic_secret" "ci_account_key" {
  path = "${var.vault_path_prefix}/${var.owner}/common/ci/ci-account.json"
  data_json = "${base64decode(google_service_account_key.ci_account_key.private_key)}"
}
