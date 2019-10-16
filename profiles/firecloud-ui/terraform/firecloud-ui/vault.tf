resource "vault_generic_secret" "hostname" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "hostname": "${module.load-balanced-instances.service_hostname}"
}
EOT
}

resource "vault_generic_secret" "bucket" {
  path = "${var.vault_path_prefix}/${var.service}/alerts_bucket"

  data_json = <<EOT
{
  "url": "https://storage.googleapis.com/${google_storage_bucket.alerts.name}"
}
EOT
}
