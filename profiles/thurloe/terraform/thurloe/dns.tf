provider "google" {
  alias = "dns"
  project     = "${var.dns_project}"
  region      = "${var.dns_region}"
  credentials = "${file("dns_sa.json")}"
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

data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "dsde-perf-broad"
}

# Instance DNS
resource "google_dns_record_set" "instance-dns-new" {
  provider     = "google.dns"
  count        = "${var.instance_num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-%02d.%s",count.index+1,data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.instances", "data.google_dns_managed_zone.dns-zone"]
}

# Service DNS
resource "google_dns_record_set" "app-dns-new" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${var.owner}-${var.service}.${data.google_dns_managed_zone.dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.load-balancer.load_balancer_public_ip}" ]
  depends_on   = ["module.load-balancer", "data.google_dns_managed_zone.terra-env-dns-zone"]
}
