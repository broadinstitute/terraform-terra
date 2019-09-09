resource "vault_generic_secret" "hostname" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"
  
  data_json = <<EOT
{
  "hostname": "${module.load-balanced-instances.service_hostname}"
}
EOT
}

resource "vault_generic_secret" "cors_allowed_domains" {
  path = "${var.vault_path_prefix}/${var.service}/${var.service}.conf"
  
  data_json = <<EOT
{
  "cors_allowed_domains": "${var.cors_allowed_domains}"
}
EOT
}
