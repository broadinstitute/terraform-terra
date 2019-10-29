provider vault {}

resource "random_id" "mongodb-user-password" {
  byte_length   = 16
}

resource "random_id" "mongodb-root-password" {
  byte_length   = 16
}

resource "vault_generic_secret" "app-database-credentials" {
  path = "secret/kdux/scp/${var.scp_vault_path}/mongo/user"

  data_json = <<EOT
{
  "username": "${var.mongodb_user}",
  "password": "${random_id.mongodb-user-password.hex}"
}
EOT
}

resource "vault_generic_secret" "root-database-credentials" {
  path = "secret/kdux/scp/${var.scp_vault_path}/mongo/root_user"

  data_json = <<EOT
{
  "username": "root",
  "password": "${random_id.mongodb-root-password.hex}"
}
EOT
}

resource "vault_generic_secret" "hostnames" {
  path = "${var.vault_path_prefix}/${var.service}/ip"
  data_json = <<EOT
{
  "ip": ${jsonencode(module.mongodb.instance_public_ips)}
}
EOT
}