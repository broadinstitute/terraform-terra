provider vault {}

resource "vault_generic_secret" "database-instance-name" {
  path = "${var.vault_path_prefix}/common/ssl/default_ssl_policy"

  data_json = <<EOT
{
  "name": "${google_compute_ssl_policy.default-ssl-policy.name}"
}
EOT
}
