resource "vault_generic_secret" "sam_conf" {
  path = "${var.vault_path_prefix}/sam/sam.conf"
  data_json = "${var.sam_conf}"
}
