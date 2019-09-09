provider vault {}

resource "random_string" "mongodb-replica-set-key" {
  length = 16
  special = false
}

resource "random_id" "mongodb-user-password" {
  byte_length   = 16
}

resource "random_id" "mongodb-root-password" {
  byte_length   = 16
}

resource "vault_generic_secret" "app-database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/mongo/app_user"

  data_json = <<EOT
{
  "username": "${var.service}",
  "password": "${random_id.mongodb-user-password.hex}"
}
EOT
}

resource "vault_generic_secret" "root-database-credentials" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/mongo/root_user"

  data_json = <<EOT
{
  "username": "root",
  "password": "${random_id.mongodb-root-password.hex}"
}
EOT
}

resource "vault_generic_secret" "hostnames" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostnames"
  data_json = <<EOT
{
  "hostnames": ${jsonencode(module.mongodb.instance_hostnames)},
  "priv_hostnames": ${jsonencode(module.mongodb.instance_priv_hostnames)}
}
EOT
}

resource "vault_generic_secret" "uri" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/uri"
  data_json = <<EOT
{
  "uri": "${module.mongodb.mongo_uri}",
  "priv_uri": "${module.mongodb.mongo_priv_uri}"
}
EOT
}
