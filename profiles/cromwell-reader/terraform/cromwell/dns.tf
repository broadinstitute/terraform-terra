data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "${var.dns_zone_name}"
}

resource "google_dns_record_set" "dns-cname-priv" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${var.owner}-${var.service}-priv.${data.google_dns_managed_zone.dns-zone.dns_name}"
  type         = "CNAME"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.load-balanced-instances.service_hostname}." ]
  depends_on   = [
    "module.load-balanced-instances",
    "data.google_dns_managed_zone.dns-zone"
  ]
}
