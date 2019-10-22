resource "vault_generic_secret" "url" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "hostname": "${module.load-balanced-instances.service_hostname}",
  "priv_hostname": "${substr(google_dns_record_set.dns-cname-priv.name, 0, length(google_dns_record_set.dns-cname-priv.name) - 1)}"
}
EOT
}

resource "vault_generic_secret" "app-database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/postgres/app_sql_user"

  data_json = <<EOT
{
  "username": "${var.cloudsql_app_username}",
  "password": "${random_id.user-password.hex}"
}
EOT
}

resource "vault_generic_secret" "root-database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/postgres/root_sql_user"

  data_json = <<EOT
{
  "username": "root",
  "password": "${random_id.root-password.hex}"
}
EOT
}

resource "vault_generic_secret" "database-instance-name" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/postgres/instance"

  data_json = <<EOT
{
  "name": "${module.cloudsql.cloudsql-instance-name}"
}
EOT
}
