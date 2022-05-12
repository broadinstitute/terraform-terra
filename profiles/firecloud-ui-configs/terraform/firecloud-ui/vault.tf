data "vault_generic_secret" "refresh_token_oauth" {
  path = "${var.vault_path_prefix}/common/refresh-token-oauth-credential.json"
}

data "vault_generic_secret" "alerts_bucket" {
  path = "${var.vault_path_prefix}/${var.service}/alerts_bucket"
}

data "vault_generic_secret" "orch_hostname" {
  path = "${var.vault_path_prefix}/firecloud-orchestration/secrets/hostname"
}

data "vault_generic_secret" "leo_hostname" {
  path = "${var.vault_path_prefix}/leonardo/secrets/hostname"
}

data "vault_generic_secret" "sam_hostname" {
  path = "${var.vault_path_prefix}/sam/secrets/hostname"
}

data "vault_generic_secret" "fc_ui_hostname" {
  path = "${var.vault_path_prefix}/firecloud-ui/secrets/hostname"
}

data "vault_generic_secret" "bond_url" {
  path = "${var.vault_path_prefix}/bond/secrets/url"
}

data "vault_generic_secret" "martha_urls" {
  path = "${var.vault_path_prefix}/martha/secrets/urls"
}

data "vault_generic_secret" "terra_url" {
  path = "${var.vault_path_prefix}/terra-ui/secrets/url"
}

data "vault_generic_secret" "configs" {
  for_each = var.configs_from_vault
  path = each.value["path"]
}
