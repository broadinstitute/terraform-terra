
# Thurloe Cloud SQL database
module "thurloe-cloudsql" {
  source        = "modules/cloudsql"

  enable_flag   = "${var.phase4_enable}"
  providers {
    google.target =  "google.terra-env"
  }
  project       = "${var.terra_env_project}"
  cloudsql_name = "thurloe"
  cloudsql_database_name = "${var.thurloe_cloudsql_database_name}"
  cloudsql_database_user_name = "${var.thurloe_cloudsql_app_username}"
  cloudsql_database_user_password = "${var.thurloe_cloudsql_app_password}"
  cloudsql_database_root_password = "${var.thurloe_cloudsql_root_password}"
  cloudsql_instance_labels = {
    "app" = "thurloe"
  }
}

# Thurloe Cloud SQL dns

resource "google_dns_record_set" "thurloe-mysql-instance" {
  provider     = "google.terra-env"
  count        = "${var.phase4_enable}"
  managed_zone = "${google_dns_managed_zone.dns_zone.name}"
  name         = "thurloe-mysql.${google_dns_managed_zone.dns_zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.thurloe-cloudsql.cloudsql-public-ip}" ]
  depends_on   = ["module.thurloe-cloudsql", "google_dns_managed_zone.dns_zone"]
}

# Thurloe instances

module "thurloe-instances" {
  source        = "modules/docker-instance"

  enable_flag   = "${var.phase4_enable}"
  providers {
    google.target =  "google.terra-env"
  }
  project       = "${var.terra_env_project}"
  instance_name = "thurloe"
  instance_size = "custom-4-8192"
  instance_labels = {
    "app" = "thurloe",
    "role" = "frontend",
    "ansible_branch" = "hf_terra",
    "ansible_project" = "terra-env",
  }
  instance_tags = [ "thurloe", "http-server", "https-server", "gce-lb-instance-group-member" ]
}

# Thurloe instance DNS

resource "google_dns_record_set" "thurloe-instance" {
  provider     = "google.terra-env"
  count        = "${var.phase4_enable == "1"?length(module.thurloe-instances.instance_public_ips):0}"
  managed_zone = "${google_dns_managed_zone.dns_zone.name}"
  name         = "${format("thurloe-%02d.%s",count.index+1,google_dns_managed_zone.dns_zone.dns_name)}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${element(module.thurloe-instances.instance_public_ips, count.index)}" ]
  depends_on   = ["module.thurloe-instances", "google_dns_managed_zone.dns_zone"]
}

# Thurloe Load Balancer
#  need to figure out dependency in order to ensure proper order - instances 
#  must be created before load balancer

module "thurloe-load-balancer" {
  source        = "modules/http-load-balancer"

  enable_flag   = "${var.phase4_enable}"
  providers {
    google.target =  "google.terra-env"
  }
  project       = "${var.terra_env_project}"
  load_balancer_name = "thurloe"
  load_balancer_ssl_certificates = [ "${google_compute_ssl_certificate.terra-env-wildcard-ssl-certificate-red.name}", "${google_compute_ssl_certificate.terra-env-wildcard-ssl-certificate-black.name}" ]
  load_balancer_instance_groups = "${element(module.thurloe-instances.instance_instance_group,0)}"
}

# Thurloe App/service DNS

resource "google_dns_record_set" "thurloe-app" {
  provider     = "google.terra-env"
  count        = "${var.phase4_enable}"
  managed_zone = "${google_dns_managed_zone.dns_zone.name}"
  name         = "thurloe.${google_dns_managed_zone.dns_zone.dns_name}"
  type         = "A"
  ttl          = "${var.dns_ttl}"
  rrdatas      = [ "${module.thurloe-load-balancer.load_balancer_public_ip}" ]
  depends_on   = ["module.thurloe-load-balancer", "google_dns_managed_zone.dns_zone"]
}
