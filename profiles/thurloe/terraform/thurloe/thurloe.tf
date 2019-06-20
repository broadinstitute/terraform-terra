
# Cloud SQL database
module "cloudsql" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-mysql?ref=cloudsql-mysql-0.1.0"

  providers {
    google.target =  "google"
  }
  project       = "${var.google_project}"
  cloudsql_name = "${var.owner}-${var.service}-db"
  cloudsql_database_name = "${var.cloudsql_database_name}"
  cloudsql_database_user_name = "${var.cloudsql_app_username}"
  cloudsql_database_user_password = "${var.cloudsql_app_password}"
  cloudsql_database_root_password = "${var.cloudsql_root_password}"
  cloudsql_instance_labels = {
    "app" = "${var.owner}-${var.service}"
  }
}

# Cloud SQL dns
resource "google_dns_record_set" "mysql-instance" {
  provider     = "google"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${var.owner}-${var.service}-mysql.${data.google_dns_managed_zone.terra-env-dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.cloudsql.cloudsql-public-ip}" ]
  depends_on   = ["module.cloudsql", "data.google_dns_managed_zone.terra-env-dns-zone"]
}

# Docker instance(s)
module "instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance?ref=docker-instance-0.1.1"

  providers {
    google.target =  "google"
  }
  project       = "${var.google_project}"
  instance_name = "${var.service}"
  instance_num_hosts = "${var.instance_num_hosts}"
  instance_size = "${var.instance_size}"
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
  # Do we want to add encryption to this bucket?
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

# Instance DNS
resource "google_dns_record_set" "instance-dns" {
  provider     = "google"
  count        = "${var.instance_num_hosts}"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${format("${var.service}-%02d.%s",count.index+1,data.google_dns_managed_zone.terra-env-dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.instances", "data.google_dns_managed_zone.terra-env-dns-zone"]
}

# Load Balancer
#  need to figure out dependency in order to ensure proper order - instances 
#  must be created before load balancer
#  Potential solution: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534
module "load-balancer" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/http-load-balancer?ref=http-load-balancer-0.1.0"

  providers {
    google.target =  "google"
  }
  project       = "${var.google_project}"
  load_balancer_name = "${var.owner}-${var.service}"
  load_balancer_ssl_certificates = [
    "${data.google_compute_ssl_certificate.terra-env-wildcard-ssl-certificate-red.name}",
    "${data.google_compute_ssl_certificate.terra-env-wildcard-ssl-certificate-black.name}"
  ]
  load_balancer_instance_groups = "${element(module.instances.instance_instance_group,0)}"
}

# Service DNS
resource "google_dns_record_set" "app-dns" {
  provider     = "google"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${var.service}.${data.google_dns_managed_zone.terra-env-dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.load-balancer.load_balancer_public_ip}" ]
  depends_on   = ["module.load-balancer", "data.google_dns_managed_zone.terra-env-dns-zone"]
}
