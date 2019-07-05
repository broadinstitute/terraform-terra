resource "vault_generic_secret" "opendj_keystore" {
  path = "${var.vault_path_prefix}/opendj/stores"
  data_json = "${var.opendj_keystore}"
}
