data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "${var.dns_zone_name}"
}

resource "google_dns_record_set" "dns-a" {
  provider     = "google.dns"
  count        = "${var.instance_num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-%02d.%s",count.index+1,data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.instances", "data.google_dns_managed_zone.dns-zone"]
}

resource "google_dns_record_set" "dns-a-priv" {
  provider     = "google.dns"
  count        = "${var.instance_num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-%02d-priv.%s",count.index+1,data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_private_ips, count.index)}" ]
  depends_on   = ["module.instances", "data.google_dns_managed_zone.dns-zone"]
}

resource "google_dns_record_set" "dns-cname" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${var.owner}-${var.service}.${data.google_dns_managed_zone.dns-zone.dns_name}"
  type         = "CNAME"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${var.owner}-${var.service}-01.${data.google_dns_managed_zone.dns-zone.dns_name}" ]
  depends_on   = [
    "module.instances",
    "data.google_dns_managed_zone.dns-zone"
  ]
}

resource "google_dns_record_set" "dns-cname-priv" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${var.owner}-${var.service}-priv.${data.google_dns_managed_zone.dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.instances.instance_private_ips[0]}" ]
  depends_on   = [
    "module.instances",
    "data.google_dns_managed_zone.dns-zone"
  ]
}
