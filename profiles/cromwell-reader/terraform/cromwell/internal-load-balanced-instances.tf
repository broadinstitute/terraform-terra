data "google_client_config" "dns" {
  provider = "google.dns"
}
module "load-balanced-instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/internal-load-balanced-instances?ref=internal-load-balanced-instances-0.0.1"
  providers {
    google.instances =  "google"
    google.dns =  "google.dns"
  }
  instance_project = "${var.google_project}"
  dns_zone_name = "${var.dns_zone_name}"
  config_bucket_enable = 0
  owner = "${var.owner}"
  service = "${var.service}"
  load_balancer_health_check_path = "/engine/v1/status"
  dns_project = "${data.google_client_config.dns.project}"
  google_network_name = "${var.google_network_name}"
  config_reader_service_account = "${var.config_reader_service_account}"
  instance_tags = "${var.instance_tags}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  storage_bucket_roles = "${var.storage_bucket_roles}"
  ansible_branch = "master"
}
