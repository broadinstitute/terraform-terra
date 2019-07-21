module "enable-services" {

  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.1.2"
  project = "${var.google_project}"

  providers {
    google.target = "google"
  }
  services = [
    "cloudfunctions.googleapis.com",
  ]
}
