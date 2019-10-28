# Docker instance(s)
module "mongodb" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/mongodb?ref=mongodb-cluster-0.1.4-tf-0.12"

  providers = {
    google.target =  "google",
    google.dns =  "google.dns"
  }
  project                  = "${var.google_project}"
  owner                    = "${var.owner}"
  service                  = "${var.service}"
  instance_name            = "${var.service}"
  mongodb_image_tag        = "${var.mongodb_version}"
  mongodb_service_account  = "${var.config_reader_service_account}"
  mongodb_roles            = "${var.mongodb_roles}"
  mongodb_app_username     = "${var.service}"
  mongodb_app_password     = "${random_id.mongodb-user-password.hex}"
  mongodb_root_password    = "${random_id.mongodb-root-password.hex}"
  mongodb_database         = "${var.service}"
  instance_size            = "${var.instance_size}"
  instance_image           = "${var.instance_image}"
  instance_data_disk_size  = "${var.instance_data_disk_size}"
  instance_data_disk_type  = "${var.instance_data_disk_type}"
  instance_data_disk_name  = "${var.service}-data-disk"
  instance_network_name    = "${data.google_compute_network.terra-env-network.name}"
  instance_tags            = "${var.instance_tags}"
  instance_labels          = {
    "app"             = "${var.service}",
    "owner"           = "${var.owner}",
    "role"            = "db",
    "ansible_branch"  = "gm-scp-mongo",
    "ansible_project" = "singlecell"
  }
}
