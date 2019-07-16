resource "google_dns_managed_zone" "dns_zone" {
  name        = "${var.owner}-gsuite-domain-zone"
  dns_name    = "${var.owner}.ephemeral.test.firecloud.org."
  description = "${var.owner} DNS zone for Gsuite domain"
  depends_on  = ["module.enable-services"]
}

data "google_dns_managed_zone" "intermediate_zone" {
  provider = "google.intermediate-domain-delegator"
  name = "${var.intermediate_dns_zone_name}"
}

resource "google_dns_record_set" "intermediate_zone_delegation" {
  provider = "google.intermediate-domain-delegator"
  name = "${var.owner}.${data.google_dns_managed_zone.intermediate_zone.dns_name}"
  type = "NS"
  ttl  = 300

  managed_zone = "${data.google_dns_managed_zone.intermediate_zone.name}"

  rrdatas = ["${google_dns_managed_zone.dns_zone.name_servers}"]
}
