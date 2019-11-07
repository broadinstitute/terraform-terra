resource "vault_generic_secret" "hostname" {
  path = "${var.vault_path_prefix}/deployment_manager_project"

  data_json = <<EOT
{
  "project": "${var.project_name}"
}
EOT
}
