resource "google_dns_managed_zone" "dns_zone" {
  provider = "google.intermediate-dns-zone"
  name        = "${var.intermediate_dns_zone_google_name}"
  dns_name    = "${var.intermediate_dns_zone}"
  description = "DNS zone for intermediate Gsuite domain"
}

data "google_dns_managed_zone" "parent_zone" {
  provider = "google.intermediate-dns-zone-delegation"
  name = "${var.parent_dns_zone_name}"
}

resource "google_dns_record_set" "intermediate_zone_delegation" {
  provider = "google.intermediate-dns-zone-delegation"
  name = "${var.ephemeral_zone_segment}.${data.google_dns_managed_zone.parent_zone.dns_name}"
  type = "NS"
  ttl  = 300

  managed_zone = "${data.google_dns_managed_zone.parent_zone.name}"

  rrdatas = ["${google_dns_managed_zone.dns_zone.name_servers}"]
}
