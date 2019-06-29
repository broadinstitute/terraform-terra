provider vault {}

resource "vault_generic_secret" "app-database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/mysql/app_sql_user"

  data_json = <<EOT
{
  "username": "${var.cloudsql_app_username}",
  "password": "${random_id.user-password.hex}"
}
EOT
}

resource "vault_generic_secret" "root-database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/mysql/app_sql_user"

  data_json = <<EOT
{
  "username": "root",
  "password": "${random_id.root-password.hex}"
}
EOT
}

resource "vault_generic_secret" "database-instance-name" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/mysql/instance"

  data_json = <<EOT
{
  "name": "${module.cloudsql.cloudsql-instance-name}"
}
EOT
}

resource "vault_generic_secret" "hostname" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "name": "${substr(google_dns_record_set.app-dns-new.name, 0, length(google_dns_record_set.app-dns-new.name) - 1)}"
}
EOT
}
