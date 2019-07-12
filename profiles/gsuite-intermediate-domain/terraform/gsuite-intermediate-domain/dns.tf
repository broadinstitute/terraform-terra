resource "google_dns_managed_zone" "dns_zone" {
  provider = "google.intermediate-dns-zone"
  name        = "${var.intermediate_dns_zone_google_name}"
  dns_name    = "${var.intermediate_dns_zone}"
  description = "DNS zone for intermediate Gsuite domain"
}
