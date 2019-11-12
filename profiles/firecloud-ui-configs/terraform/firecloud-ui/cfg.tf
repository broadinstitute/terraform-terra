locals {
  template_vars = {
    refresh_token_client_id = jsondecode(data.vault_generic_secret.refresh_token_oauth.data_json)["web"]["client_id"]
    google_project = var.google_project
    alerts_bucket_url = data.vault_generic_secret.alerts_bucket.data["url"]
    image = var.service_git_sha_12_char

    fc_ui_hostname = data.vault_generic_secret.fc_ui_hostname.data["hostname"]
    orch_hostname = data.vault_generic_secret.orch_hostname.data["hostname"]
    leonardo_hostname = data.vault_generic_secret.leo_hostname.data["hostname"]
    sam_hostname = data.vault_generic_secret.sam_hostname.data["hostname"]

    bond_url = data.vault_generic_secret.bond_url.data["url"]
    file_summary_url = data.vault_generic_secret.martha_urls.data["fileSummary"]
    martha_url = data.vault_generic_secret.martha_urls.data["martha"]
    tos_url = data.vault_generic_secret.tos_url.data["endpoint"]
    terra_url = data.vault_generic_secret.terra_url.data["url"]
  }
  instance_names = toset(flatten([
    for instance_url in data.google_compute_instance_group.service-instances.instances: [
      regex("/([^/]*)$", instance_url)
    ]
  ]))
  rendered_configs = tolist(
    setproduct(
      local.instance_names,
      var.configs_to_render
    )
  )
  vault_configs = tolist(
    setproduct(
      local.instance_names,
      keys(var.configs_from_vault)
    )
  )
}

resource "google_storage_bucket_object" "rendered_configs" {
  count = length(local.rendered_configs)
  name = "${local.rendered_configs[count.index][0]}/${local.rendered_configs[count.index][1]}"
  content = templatefile("${path.module}/${local.rendered_configs[count.index][1]}.tpl", local.template_vars)
  bucket = var.config_bucket_name
}

resource "google_storage_bucket_object" "vault_configs" {
  count = length(local.vault_configs)
  name = "${local.vault_configs[count.index][0]}/${local.vault_configs[count.index][1]}"
  content = data.vault_generic_secret.configs[
    local.vault_configs[count.index][1]].data[
      var.configs_from_vault[
        local.vault_configs[count.index][1]
      ]["key"]
  ]
  bucket = var.config_bucket_name
}
