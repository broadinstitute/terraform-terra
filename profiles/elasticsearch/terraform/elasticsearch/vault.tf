provider vault {}

resource "vault_generic_secret" "service-hostname" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "hostname": "${length(module.elasticsearch.instance_hostnames) > 0 ? element(module.elasticsearch.instance_hostnames, 0) : ""}",
  "priv_hostname": "${length(module.elasticsearch.instance_hostnames) > 0 ? element(module.elasticsearch.instance_priv_hostnames, 0) : ""}"
}
EOT
  depends_on = [module.elasticsearch]
}

resource "vault_generic_secret" "hostnames" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostnames"
  data_json = <<EOT
{
  "hostnames": ${jsonencode(module.elasticsearch.instance_hostnames)},
  "priv_hostnames": ${jsonencode(module.elasticsearch.instance_priv_hostnames)}
}
EOT
}

resource "vault_generic_secret" "instance-hostnames-by-instance-name" {
  count = "${length(module.elasticsearch.instance_hostnames)}"
  path = "${var.vault_path_prefix}/${var.service}/secrets/${element(module.elasticsearch.instance_names, count.index)}/instance-hostnames"

  data_json = <<EOT
{
  "hostname": "${length(module.elasticsearch.instance_hostnames) > 0 ? element(module.elasticsearch.instance_hostnames, count.index) : ""}",
  "priv_hostname": "${length(module.elasticsearch.instance_hostnames) > 0 ?  element(module.elasticsearch.instance_priv_hostnames, count.index) : ""}"
}
EOT
}
