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
  path = "${var.vault_path_prefix}/${var.service}/secrets/mysql/root_sql_user"

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
  "hostname": "${data.null_data_source.hostnames_with_no_trailing_dot.outputs.hostname}"
}
EOT
}

resource "vault_generic_secret" "service-bucket" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/service-bucket"

  data_json = <<EOT
{
  "name": "${google_storage_bucket.service-bucket.name}"
}
EOT
}