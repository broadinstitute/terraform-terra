
# firewall rules that allow stackdriver status checks

resource "google_compute_firewall" "stackdriver-allow-https" {
  provider = "google-beta"
  enable_logging = var.enable_logging
  name = "${var.owner}-stackdriver-allow-https"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = var.stackdriver_range_cidrs
  target_tags = [ "http-server" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}
