# Docker instance(s)
module "instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance-data-disk?ref=docker-instance-data-disk-0.1.3"

  providers {
    google.target =  "google"
  }
  project       = "${var.google_project}"
  instance_name = "${var.service}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  instance_data_disk_size = "${var.instance_data_disk_size}"
  instance_data_disk_type = "${var.instance_data_disk_type}"
  instance_data_disk_name = "${var.service}-data-disk"
  instance_service_account = "${data.google_service_account.config_reader.email}"
  instance_network_name = "${data.google_compute_network.terra-env-network.name}"
  instance_labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "frontend",
    "ansible_branch" = "rl-add-services",
    "ansible_project" = "terra-env",
  }
  instance_tags = "${var.instance_tags}"
}

# Service config bucket
resource "google_storage_bucket" "config-bucket" {
  name       = "${var.owner}-${var.service}-config"
  project    = "${var.google_project}"
  versioning = {
    enabled = "true"
  }
  force_destroy = true
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "config"
  }
}

# Grant service account access to the config bucket
resource "google_storage_bucket_iam_member" "app_config" {
  count = "${length(var.storage_bucket_roles)}"
  bucket = "${google_storage_bucket.config-bucket.name}"
  role   = "${element(var.storage_bucket_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.config_reader.email}"
}
