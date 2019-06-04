
resource "google_dns_managed_zone" "dns_zone" {
  provider    = "google.terra-env"
  count       = "${var.phase3_enable}"
  name        = "${var.dns_name}"
  dns_name    = "${var.dns_domain}."
  description = "${var.dns_domain} zone"
  depends_on  = ["module.enable-services"]
}

