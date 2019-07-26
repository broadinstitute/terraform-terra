resource "vault_generic_secret" "url" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "hostname": "${module.load-balanced-instances.service_hostname}",
  "priv_hostname": "${substr(google_dns_record_set.dns-cname-priv.name, 0, length(google_dns_record_set.dns-cname-priv.name) - 1)}"
}
EOT
}
