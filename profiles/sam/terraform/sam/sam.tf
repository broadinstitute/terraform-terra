provider "google" {
  alias = "dns"
  project     = "${var.dns_project}"
  region      = "${var.dns_region}"
  credentials = "${file("dns_sa.json")}"
}

module "load-balanced-instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/load-balanced-instances?ref=rl-load-balanced-instances"
  providers {
    google.instances =  "google"
    google.dns =  "google.dns"
  }
  instance_project = "${var.google_project}"
  dns_zone_name = "${var.dns_zone_name}"
  owner = "${var.owner}"
  service = "${var.service}"
  dns_project = "${var.dns_project}"
  dns_region = "${var.dns_region}"
  google_compute_ssl_certificate_black = "${var.google_compute_ssl_certificate_black}"
  google_compute_ssl_certificate_red = "${var.google_compute_ssl_certificate_red}"
  google_network_name = "${var.google_network_name}"
  config_reader_service_account = "${var.config_reader_service_account}"
  instance_tags = "${var.instance_tags}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  storage_bucket_roles = "${var.storage_bucket_roles}"
}
