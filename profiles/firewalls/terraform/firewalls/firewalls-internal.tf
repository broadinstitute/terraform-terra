
resource "google_compute_firewall" "managed_broad_allow_opendj_internal" {
  name = "managed-broad-allow-opendj-internal"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "389", "636","4444","8443" ]
  }

  source_ranges = [ "${split(",", var.internal_range)}" ]
  target_tags = [ "opendj" ]
}
