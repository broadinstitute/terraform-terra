provider vault {}

resource "vault_generic_secret" "service-hostname" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "hostname": "${substr(google_dns_record_set.dns-cname.name, 0, length(google_dns_record_set.dns-cname.name) - 1)}",
  "priv_hostname": "${substr(google_dns_record_set.dns-cname-priv.name, 0, length(google_dns_record_set.dns-cname-priv.name) - 1)}"
}
EOT
}

data "null_data_source" "hostnames_with_no_trailing_dot" {
  count = "${length(google_dns_record_set.dns-a.*.name)}"
  inputs = {
    hostname = "${substr(element(google_dns_record_set.dns-a.*.name, count.index), 0, length(element(google_dns_record_set.dns-a.*.name, count.index)) - 1)}"
    hostname_priv = "${substr(element(google_dns_record_set.dns-a-priv.*.name, count.index), 0, length(element(google_dns_record_set.dns-a-priv.*.name, count.index)) - 1)}"
  }
}

resource "vault_generic_secret" "instance-hostnames" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/instance-hostnames"

  data_json = <<EOT
{
  "hostnames": ${jsonencode(data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname)},
  "priv_hostnames": ${jsonencode(data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname_priv)}
}
EOT
}

resource "vault_generic_secret" "instance-hostnames-by-instance-name" {
  count = "${length(module.instances.instance_names)}"
  path = "${var.vault_path_prefix}/${var.service}/secrets/${element(module.instances.instance_names, count.index)}/instance-hostnames"

  data_json = <<EOT
{
  "hostname": "${element(data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname, count.index)}",
  "priv_hostname": "${element(data.null_data_source.hostnames_with_no_trailing_dot.*.outputs.hostname_priv, count.index)}"
}
EOT
}
