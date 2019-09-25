provider "vault" {}

data "vault_generic_secret" "legacy_oauth_ids" {
  path = "secret/dsde/firecloud/common/oauth_client_id"
}
data "google_service_account" "firecloud_orchestration" {
  account_id = "${var.firecloud_orchestration_service_account}"
}

data "null_data_source" "env_specific_oauth_ids" {
  inputs = {
    firecloud_orchestration_id = data.google_service_account.firecloud_orchestration.unique_id
  }
}

output "oauth" {
  value = merge(jsondecode(data.vault_generic_secret.legacy_oauth_ids.data["client_ids"]), data.null_data_source.env_specific_oauth_ids.outputs)
}
resource "vault_generic_secret" "example" {
  path = "${var.vault_path_prefix}/common/oauth_client_id"

  data_json = <<EOT
  { "client_ids": ${jsonencode(merge(jsondecode(data.vault_generic_secret.legacy_oauth_ids.data["client_ids"]), data.null_data_source.env_specific_oauth_ids.outputs))}
}
EOT
}
