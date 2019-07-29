output "authorized_javascript_origins" {
  value = [
    "https://${module.load-balanced-instances.service_hostname}",
  ]
}

output "authorized_redirect_urls" {
  value = [
    "https://${module.load-balanced-instances.service_hostname}/swagger/oauth2-redirect.html",
    "https://${module.load-balanced-instances.service_hostname}/swagger/callback",
    "https://${module.load-balanced-instances.service_hostname}/swagger/o2c.html",
  ]
}
