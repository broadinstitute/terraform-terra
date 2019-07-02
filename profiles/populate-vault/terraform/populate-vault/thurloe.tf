resource "vault_generic_secret" "thurloe_keys" {
  path = "${var.vault_path_prefix}/thurloe/secrets/keys"
  data_json = "${var.thurloe_keys_json}"
}
