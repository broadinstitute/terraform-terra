data "null_data_source" "dns_zone_no_trailing_dot" {
  inputs = {
    zone = "${substr(data.google_dns_managed_zone.dns-zone.dns_name, 0, length(data.google_dns_managed_zone.dns-zone.dns_name) - 1)}"
  }
}

output "authorized_javascript_origins" {
  value = [
    "https://${module.load-balanced-instances.service_hostname}",
    "https://${var.owner}-firecloud.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}",
  ]
}

output "authorized_redirect_urls" {
  value = [
    "https://${module.load-balanced-instances.service_hostname}/oauth2callback",
    "https://${module.load-balanced-instances.service_hostname}/o2c.html",
    "https://${var.owner}-firecloud.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-firecloud.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
  ]
}

output "vault_path_for_oauth_client_json" {
  value = "${var.vault_path_prefix}/leonardo/leonardo-oauth-credential.json"
}
