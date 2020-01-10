resource "google_compute_network" "vpc-network" {          
  provider                = "google-beta"                                  
  project                 = var.google_project
  name                    = var.network_name            
  auto_create_subnetworks = true
}

provider "google-beta" {
  credentials = "${file("default.sa.json")}"
  project     = var.google_project
  region      = "us-central1"
}
