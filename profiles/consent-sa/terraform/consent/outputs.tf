output "ATTENTION" {
  value = <<EOF
THIS PROFILE REQUIRES MANUAL STEPS!
To run the manual steps run the script in the profile root:
python manual_steps.py [google-project-name]
EOF
}

data "null_data_source" "dns_zone_no_trailing_dot" {
  inputs = {
    zone = "${substr(data.google_dns_managed_zone.dns-zone.dns_name, 0, length(data.google_dns_managed_zone.dns-zone.dns_name) - 1)}"
  }
}

output "authorized_javascript_origins" {
  value = [
    "https://${var.owner}-duos.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}",
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}"
  ]
}

output "authorized_redirect_urls" {
  value = [
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-duos.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/oauth2callback",
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/api",
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}/swagger/o2c.html",
    "https://${var.owner}-${var.service}.${data.null_data_source.dns_zone_no_trailing_dot.outputs.zone}"
  ]
}

output "vault_path_for_oauth_client_json" {
  value = "${var.vault_path_prefix}/${var.service}/${var.service}-oauth-credential.json"
}
