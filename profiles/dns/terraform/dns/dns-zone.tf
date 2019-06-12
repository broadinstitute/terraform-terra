resource "google_dns_managed_zone" "dns_zone" {
  name        = "${var.owner}-terra-dns"
  dns_name    = "${var.owner}-terra-dns.broadinstitute.org."
  description = "${var.owner}-terra-dns zone"
  depends_on  = ["module.enable-services"]
}
