
# firewall rules that allow Google GLB health checkers

# IP ranges for GCE Load Balancers
variable "google_lb_ranges" {
  type        = "list"
  default     = [ "130.211.0.0/22", "35.191.0.0/16" ]
  description = "IP ranges used for health checks by GCE load balancers"
}

resource "google_compute_firewall" "terra-gce-lb-health-check-allow-http" {
  provider = "google-beta"
  enable_logging = var.enable_logging
  name = "${var.owner}-lb-health-check-allow-http"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "80" ]
  }

  source_ranges = var.google_lb_ranges
  target_tags = [ "gce-lb-instance-group-member" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-gce-lb-health-check-allow-https" {
  provider = "google-beta"
  enable_logging = var.enable_logging
  name = "${var.owner}-lb-health-check-allow-https"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = var.google_lb_ranges
  target_tags = [ "gce-lb-instance-group-member" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}
