data "google_dns_managed_zone" "terra-env-dns-zone" {
  name = "${var.old_dns_zone}"
}

resource "random_id" "user-password" {
  byte_length   = 16
}

resource "random_id" "root-password" {
  byte_length   = 16
}

# Cloud SQL database
module "cloudsql" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-mysql?ref=cloudsql-mysql-0.1.1"

  providers {
    google.target =  "google"
  }
  project       = "${var.google_project}"
  cloudsql_name = "${var.owner}-${var.service}-db"
  cloudsql_database_name = "${var.cloudsql_database_name}"
  cloudsql_database_user_name = "${var.cloudsql_app_username}"
  cloudsql_database_user_password = "${random_id.user-password.hex}"
  cloudsql_database_root_password = "${random_id.root-password.hex}"
  cloudsql_instance_labels = {
    "app" = "${var.owner}-${var.service}"
  }
}

resource "google_project_iam_member" "app-sa-roles" {
  count = "${length(var.service_account_iam_roles)}"
  project = "${var.google_project}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${data.google_service_account.config_reader.email}"
}

module "load-balanced-instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/load-balanced-instances?ref=load-balanced-instances-0.0.3"
  providers {
    google.instances =  "google"
    google.dns =  "google.dns"
  }
  instance_project = "${var.google_project}"
  dns_zone_name = "${var.dns_zone_name}"
  owner = "${var.owner}"
  service = "${var.service}"
  dns_project = "${var.dns_project}"
  google_compute_ssl_certificate_black = "${var.google_compute_ssl_certificate_black}"
  google_compute_ssl_certificate_red = "${var.google_compute_ssl_certificate_red}"
  google_network_name = "${var.google_network_name}"
  config_reader_service_account = "${var.config_reader_service_account}"
  instance_tags = "${var.instance_tags}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
  storage_bucket_roles = "${var.storage_bucket_roles}"
  ansible_branch = "perf-146-sam-opendj"
}
