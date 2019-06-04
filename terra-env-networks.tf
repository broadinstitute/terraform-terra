resource "google_compute_network" "app-services-net" {
  provider                = "google.terra-env"
  count                   = "${var.phase3_enable}"
  name                    = "${var.terra_env_network_name}"
  auto_create_subnetworks = "true"
  depends_on              = ["module.enable-services"]
}
