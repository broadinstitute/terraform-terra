resource "google_compute_network" "terra-app-services-net" {
  provider                = "google"
  name                    = "${var.owner}-terra-network"
  auto_create_subnetworks = "true"
  depends_on              = ["module.enable-services"]
}
