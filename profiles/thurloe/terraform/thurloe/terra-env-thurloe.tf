
# Cloud SQL database
module "terra-cloudsql" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/cloudsql-mysql?ref=rl-add-modules"

  providers {
    google.target =  "google"
  }
  project       = "${var.terra_google_project}"
  cloudsql_name = "${var.terra_owner}-terra-${var.terra_service}-db"
  cloudsql_database_name = "${var.cloudsql_database_name}"
  cloudsql_database_user_name = "${var.cloudsql_app_username}"
  cloudsql_database_user_password = "${var.cloudsql_app_password}"
  cloudsql_database_root_password = "${var.cloudsql_root_password}"
  cloudsql_instance_labels = {
    "app" = "${var.terra_owner}-terra-${var.terra_service}"
  }
}

# Cloud SQL dns
resource "google_dns_record_set" "terra-mysql-instance" {
  provider     = "google"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${var.terra_owner}-terra-${var.terra_service}-mysql.${data.google_dns_managed_zone.terra-env-dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.terra-cloudsql.cloudsql-public-ip}" ]
  depends_on   = ["module.terra-cloudsql", "data.google_dns_managed_zone.terra-env-dns-zone"]
}


# Docker instance(s)
module "terra-instances" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/docker-instance?ref=rl-add-modules"

  providers {
    google.target =  "google"
  }
  project       = "${var.terra_google_project}"
  instance_name = "${var.terra_service}"
  instance_size = "${var.instance_size}"
  instance_network_name = "${data.google_compute_network.terra-env-network.name}"
  instance_labels = {
    "app" = "${var.terra_service}",
    "owner" = "${var.terra_owner}",
    "role" = "frontend",
    "ansible_branch" = "hf_terra",
    "ansible_project" = "terra-env",
  }
  instance_tags = "${var.instance_tags}"
}

# Instance DNS
resource "google_dns_record_set" "terra-instance-dns" {
  provider     = "google"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${format("${var.terra_service}-%02d.%s",count.index+1,data.google_dns_managed_zone.terra-env-dns-zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.terra-instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.terra-instances", "data.google_dns_managed_zone.terra-env-dns-zone"]
}

# Load Balancer
#  need to figure out dependency in order to ensure proper order - instances 
#  must be created before load balancer
#  Potential solution: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534
module "terra-load-balancer" {
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/http-load-balancer?ref=rl-add-modules"

  providers {
    google.target =  "google"
  }
  project       = "${var.terra_google_project}"
  load_balancer_name = "${var.terra_owner}-terra-${var.terra_service}"
  load_balancer_ssl_certificates = [
    "${data.google_compute_ssl_certificate.terra-env-wildcard-ssl-certificate-red.name}",
    "${data.google_compute_ssl_certificate.terra-env-wildcard-ssl-certificate-black.name}"
  ]
  load_balancer_instance_groups = "${element(module.terra-instances.instance_instance_group,0)}"
}

# Service DNS
resource "google_dns_record_set" "terra-app-dns" {
  provider     = "google"
  managed_zone = "${data.google_dns_managed_zone.terra-env-dns-zone.name}"
  name         = "${var.terra_service}.${data.google_dns_managed_zone.terra-env-dns-zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.terra-load-balancer.load_balancer_public_ip}" ]
  depends_on   = ["module.terra-load-balancer", "data.google_dns_managed_zone.terra-env-dns-zone"]
}
