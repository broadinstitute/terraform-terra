module "load-balanced-instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/load-balanced-instances?ref=load-balanced-instances-0.2.0-tf-0.12"
  providers = {
    google.instances =  "google"
    google.dns =  "google.dns"
  }
  instance_project = "${var.google_project}"
  instance_image = "${var.instance_image}"
  dns_zone_name = "${var.dns_zone_name}"
  owner = "${var.owner}"
  service = "${var.service}"
  dns_project = "${var.dns_project}"
  ssl_policy_name = "${var.default_ssl_policy}"
  google_compute_ssl_certificate_black = "${var.google_compute_ssl_certificate_black}"
  google_compute_ssl_certificate_red = "${var.google_compute_ssl_certificate_red}"
  google_network_name = "${var.google_network_name}"
  config_reader_service_account = "${var.config_reader_service_account}"
  instance_tags = "${var.instance_tags}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  storage_bucket_roles = "${var.storage_bucket_roles}"
}
