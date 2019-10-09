module "network" {
  # "github.com/" + org + "/" + repo name + ".git" + "//" + path within repo to base dir + "?ref=" + git object ref
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/logged-network?ref=logged-network-0.0.0-tf-0.12"
  google_project     = var.google_project
  network_name                    = "${var.owner}-terra-network"
  enable_flow_logs = false
  providers = {
    "google-beta.target" = "google-beta"
    "google.target" = "google"
  }
}

provider "google-beta" {
  credentials = "${file("default.sa.json")}"
  project     = var.google_project
  region      = "us-central1"
}
