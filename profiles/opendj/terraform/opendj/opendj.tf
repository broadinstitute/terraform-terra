resource "random_id" "dirmanagerpw" {
  byte_length   = 16
}

resource "random_id" "keystorepin" {
  byte_length   = 16
}

# Docker instance(s)
module "instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance-data-disk?ref=docker-instance-data-disk-0.1.1"

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
    "ansible_branch" = "master",
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

# Instance A DNS
resource "google_dns_record_set" "instance-dns-a" {
  provider     = "google"
  count        = "${var.instance_num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${format("${var.service}-%02d.%s",count.index+1,data.google_dns_managed_zone.terra-env-dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.instances", "data.google_dns_managed_zone.terra-env-dns-zone"]
}

# Instance CNAME DNS
resource "google_dns_record_set" "instance-dns-cname" {
  provider     = "google"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${var.service}.${data.google_dns_managed_zone.terra-env-dns-zone.dns_name}"
  type         = "CNAME"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${var.service}-01.${data.google_dns_managed_zone.terra-env-dns-zone.dns_name}" ]
  depends_on   = [
    "module.instances",
    "data.google_dns_managed_zone.terra-env-dns-zone"
  ]
}
