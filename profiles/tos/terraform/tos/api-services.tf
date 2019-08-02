module "enable-services" {

  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/api-services?ref=services-0.2.0-tf-0.12"
  project = "${var.google_project}"

  providers {
    google.target = "google"
  }
  services = [
    "cloudfunctions.googleapis.com",
  ]
}
