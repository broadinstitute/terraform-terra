# Docker instance(s)
module "elasticsearch" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/elasticsearch?ref=elasticsearch-module"

  providers = {
    google.target =  "google",
    google.dns =  "google.dns"
  }
  project                  = "${var.google_project}"
  owner                    = "${var.owner}"
  service                  = "${var.service}"
  instance_name            = "${var.service}"
  application_service_account  = "${var.config_reader_service_account}"
  dns_zone_name            = "${var.dns_zone_name}"
  instance_size            = "${var.instance_size}"
  instance_data_disk_size  = "${var.instance_data_disk_size}"
  instance_data_disk_type  = "${var.instance_data_disk_type}"
  instance_data_disk_name  = "${var.service}-data-disk"
  instance_network_name    = "${data.google_compute_network.terra-env-network.name}"
  instance_tags            = "${var.instance_tags}"
  instance_labels          = {
    "app"             = "${var.service}",
    "owner"           = "${var.owner}",
    "role"            = "db",
    "ansible_branch"  = "master",
    "ansible_project" = "terra-env",
  }
}
