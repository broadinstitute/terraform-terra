provider "google" {
  alias = "dns"
  project     = "${var.dns_project}"
  region      = "${var.dns_region}"
  credentials = "${file("dns_sa.json")}"
}

data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "dsde-perf-broad"
}

# Cloud SQL dns
resource "google_dns_record_set" "mysql-instance-new" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${var.owner}-${var.service}-mysql.${data.google_dns_managed_zone.dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.cloudsql.cloudsql-public-ip}" ]
  depends_on   = ["module.cloudsql"]
}
