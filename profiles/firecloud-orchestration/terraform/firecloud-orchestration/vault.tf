resource "vault_generic_secret" "url" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/hostname"

  data_json = <<EOT
{
  "hostname": "${module.load-balanced-instances.service_hostname}",
  "priv_hostname": "${substr(google_dns_record_set.dns-cname-priv.name, 0, length(google_dns_record_set.dns-cname-priv.name) - 1)}"
}
EOT
}

resource "vault_generic_secret" "whitelist-bucket" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/whitelist-bucket"

  data_json = <<EOT
{
  "name": "${google_storage_bucket.whitelist-bucket.name}"
}
EOT
}

data "vault_generic_secret" "qa_user_pass" {
  path = "secret/dsde/firecloud/qa/common/users"
}

resource "vault_generic_secret" "test-user-data" {
  path = "${var.vault_path_prefix}/common/users"

  data_json = <<EOT
{
    "automation_users_passwd": "${data.vault_generic_secret.qa_user_pass.data["automation_users_passwd"]}",
    "billing_acct": "Broad Institute - 8201528",
    "service_acct_email": "${data.google_service_account.config_reader.email}",
    "users_passwd": "${data.vault_generic_secret.qa_user_pass.data["automation_users_passwd"]}"
}
EOT
}
