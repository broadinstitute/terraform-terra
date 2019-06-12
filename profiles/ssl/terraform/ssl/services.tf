module "enable-services" {

  source   = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.1.2"

  providers {
    google.target =  "google"
  }
  project  = "${var.google_project}"
  services = [
    "compute.googleapis.com",
  ]
}
