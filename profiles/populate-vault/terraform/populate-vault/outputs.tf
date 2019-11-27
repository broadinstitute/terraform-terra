output "ATTENTION" {
  value = "\nTHIS PROFILE REQUIRES MANUAL STEPS!\nRun 'python manual_steps.py' in the profile folder in another console tab!\n\n"
}

data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "${var.dns_zone_name}"
}

data "null_data_source" "dns_zone_no_trailing_dot" {
  inputs = {
    zone = "${substr(data.google_dns_managed_zone.dns-zone.dns_name, 0, length(data.google_dns_managed_zone.dns-zone.dns_name) - 1)}"
  }
}

output "authorized_javascript_origins" {
  value = [
    "https://${var.owner}-firecloud-ui.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}",
  ]
}

output "authorized_redirect_urls" {
  value = [
    "https://${var.owner}-firecloud-ui.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-firecloud-ui.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-firecloud-orchestration.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-firecloud-orchestration.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-rawls.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-sam.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-leonardo.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html"
  ]
}

output "vault_path_for_oauth_client_json" {
  value = "${var.vault_path_prefix}/common/refresh-token-oauth-credential.json"
}
