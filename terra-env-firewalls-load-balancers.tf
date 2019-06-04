
# firewall rules that allow Google GLB health checkers

# IP ranges for GCE Load Balancers
variable "google_lb_ranges" {
  type        = "list"
  default     = [ "130.211.0.0/22", "35.191.0.0/16" ]
  description = "IP ranges used for health checks by GCE load balancers"
}

resource "google_compute_firewall" "gce-lb-health-check-allow-http" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "gce-lb-health-check-allow-http"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "80" ]
  }

  source_ranges = [ "${var.google_lb_ranges}" ]
  target_tags = [ "gce-lb-instance-group-member" ]
}

resource "google_compute_firewall" "gce-lb-health-check-allow-https" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "gce-lb-health-check-allow-https"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = [ "${var.google_lb_ranges}" ]
  target_tags = [ "gce-lb-instance-group-member" ]
}

