resource "vault_generic_secret" "common_secrets" {
  path = "${var.vault_path_prefix}/common/secrets"
  data_json = "${var.common_secrets_json}"
}
