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
  "name": "${module.cloudsql.cloudsql-instance-name}",
  "hostname": "${google_dns_record_set.mysql-instance-new.name}"
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
resource "vault_generic_secret" "cloudsql_truststore_keystore" {
  path = "${var.vault_path_prefix}/consent/${var.service}-mysql"
  depends_on = [
    "data.local_file.truststore",
    "data.local_file.keystore"
  ]
  data_json = <<EOT
{
  "truststore": "${data.local_file.truststore.content_base64}",
  "keystore": "${data.local_file.keystore.content_base64}",
  "client_key": "${replace(google_sql_ssl_cert.client_cert.private_key, "\n", "\\n")}",
  "client_cert": "${replace(google_sql_ssl_cert.client_cert.cert, "\n", "\\n")}",
  "server_ca": "${replace(google_sql_ssl_cert.client_cert.server_ca_cert, "\n", "\\n")}"
}
EOT
}
