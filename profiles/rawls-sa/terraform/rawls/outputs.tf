output "ATTENTION!!!" {
  value = "\nTHIS PROFILE REQUIRES MANUAL STEPS!\nRun 'python manual_steps.py' in the profile folder in another console tab!\n\n"
}

data "null_data_source" "dns_zone_no_trailing_dot" {
  inputs = {
    zone = "${substr(data.google_dns_managed_zone.dns-zone.dns_name, 0, length(data.google_dns_managed_zone.dns-zone.dns_name) - 1)}"
  }
}

output "rawls_sa_id" {
  value = "${google_service_account.app.unique_id}"
}

output "authorized_javascript_origins" {
  value = [
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}",
    "https://${var.owner}-firecloud.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}"
  ]
}

output "authorized_redirect_urls" {
  value = [
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-firecloud.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-firecloud.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-firecloud-orchestration.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-sam.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html",
    "https://${var.owner}-thurloe.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/o2c.html"
  ]
}
