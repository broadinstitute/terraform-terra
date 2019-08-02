module "enable-services" {
  source      = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.1.2"
  enable_flag = "0"
  providers {
    google.target = "google.app-engine"
  }
  project     = "${var.google_project}"
  services    = [
    "appengine.googleapis.com",
  ]
}
