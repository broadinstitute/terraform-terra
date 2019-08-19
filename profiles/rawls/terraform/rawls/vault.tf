data "vault_generic_secret" "perf_rawls_conf" {
  path = "${var.vault_path_prefix}/rawls/rawls-perf.conf"
}

resource "vault_generic_secret" "app-config" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}.conf"
  depends_on = ["data.vault_generic_secret.perf_rawls_conf"]
  data_json = <<EOT
{
  "slick_db_user": "${var.cloudsql_app_username}",
  "slick_db_password": "${random_id.user-password.hex}",
  "gcs_tokenEncryptionKey": "${data.vault_generic_secret.perf_rawls_conf.data["gcs_tokenEncryptionKey"]}"
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
  "hostname": "${module.load-balanced-instances.service_hostname}"
}
EOT
}
