resource "google_compute_network" "k8s-cluster-network" {          
  provider                = "google-beta"                                  
  project                 = var.google_project
  name                    = var.cluster_network
  depends_on              = [module.enable-services]                
  auto_create_subnetworks = true
}

provider "google-beta" {
  credentials = "${file("default.sa.json")}"
  project     = var.google_project
  region      = "us-central1"
}
