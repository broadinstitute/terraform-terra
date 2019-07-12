resource "google_dns_managed_zone" "dns_zone" {
  name        = "${var.owner}-gsuite-domain-zone"
  dns_name    = "${var.owner}.test.firecloud.org."
  description = "${var.owner} DNS zone for Gsuite domain"
  depends_on  = ["module.enable-services"]
}
