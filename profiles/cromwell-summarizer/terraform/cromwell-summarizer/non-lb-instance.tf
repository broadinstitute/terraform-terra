module "instance" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance?ref=docker-instance-0.1.1"

  providers {
    google.target =  "google"
  }
  project       = "${var.google_project}"
  instance_name = "${var.service}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  instance_service_account = "${data.google_service_account.config_reader.email}"
  instance_network_name = "${var.google_network_name}"
  instance_labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "ansible_branch" = "rl-add-services",
    "ansible_project" = "terra-env",
  }
  instance_tags = "${var.instance_tags}"
}

data "google_dns_managed_zone" "dns-zone" {
  provider = "google.dns"
  name = "${var.dns_zone_name}"
}

resource "google_dns_record_set" "instance-dns" {
  provider     = "google.dns"
  managed_zone = "${data.google_dns_managed_zone.dns-zone.name}"
  name         = "${format("${var.owner}-${var.service}-backend.%s",data.google_dns_managed_zone.dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instance.instance_public_ips, count.index)}" ]
  depends_on   = ["module.instance", "data.google_dns_managed_zone.dns-zone"]
}
