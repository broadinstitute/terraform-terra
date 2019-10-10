module "enable-services" {
  source      = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.2.0-tf-0.12"
  enable_flag = "1"
  providers = {
    google.target = "google"
  }
  project     = "${var.google_project}"
  services    = [
    "stackdriver.googleapis.com",
    "logging.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "pubsub.googleapis.com",
    "compute.googleapis.com"
  ]
}
