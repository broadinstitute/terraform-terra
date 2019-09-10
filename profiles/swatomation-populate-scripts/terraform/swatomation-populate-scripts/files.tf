resource "local_file" "populate-environment" {
    content     = templatefile("${path.module}/populate-environment.sh.tmpl", 
    { environment = var.environment,
      orch_hostname = data.vault_generic_secret.orch_hostname.data["hostname"],
      sam_hostname = data.vault_generic_secret.sam_hostname.data["hostname"],
    })
    filename = "${path.module}/populate-environment.sh"
}

data "vault_generic_secret" "orch_hostname" {
  path = "${var.vault_path_prefix}/${var.orchestration_service_name}/secrets/hostname"
}

data "vault_generic_secret" "sam_hostname" {
  path = "${var.vault_path_prefix}/${var.sam_service_name}/secrets/hostname"
}
