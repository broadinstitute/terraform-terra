module "enable-services" {


  source   = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.1.2"

  enable_flag    = "${var.phase2_enable}"
  providers {
    google.target =  "google.terra-env"
  }
  project  = "${var.terra_env_project}"
  services = [
    "iamcredentials.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "dataproc.googleapis.com",
    "dns.googleapis.com",
    "genomics.googleapis.com",
    "iam.googleapis.com",
    "stackdriver.googleapis.com",
    "logging.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "serviceusage.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "cloudapis.googleapis.com",
  ]
}
