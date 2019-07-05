resource "vault_generic_secret" "opendj_secrets" {
  path = "${var.vault_path_prefix}/opendj/secrets"
  data_json = "${var.opendj_secrets}"
}

resource "vault_generic_secret" "opendj_keystore" {
  path = "${var.vault_path_prefix}/opendj/stores"
  data_json = "${var.opendj_keystore}"
}
