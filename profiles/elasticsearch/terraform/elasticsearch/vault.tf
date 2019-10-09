provider vault {}

resource "vault_generic_secret" "clustername" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/clustername"
  data_json = <<EOT
{
  "name": "${module.elasticsearch.cluster_name}"
}
EOT
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

resource "vault_generic_secret" "hostname" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"
  data_json = <<EOT
{
  "hostname": "${length(module.elasticsearch.instance_hostnames) > 0 ? element(module.elasticsearch.instance_hostnames, 0) : ""}",
  "priv_hostname": "${length(module.elasticsearch.instance_hostnames) > 0 ? element(module.elasticsearch.instance_priv_hostnames, 0) : ""}"
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
