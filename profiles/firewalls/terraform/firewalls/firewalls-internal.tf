
resource "google_compute_firewall" "managed_broad_allow_opendj_internal" {
  name = "managed-broad-allow-opendj-internal"
  network = "${data.google_compute_network.terra-env-network.name}"
  depends_on = [ "data.google_compute_network.terra-env-network" ]

  allow {
    protocol = "tcp"
    ports = [ "389", "636","4444","8443" ]
  }

  source_ranges = [ "${split(",", var.internal_range)}" ]
  target_tags = [ "opendj" ]
}

resource "google_compute_firewall" "managed_managed_allow_mongo_client" {
  name = "managed-managed-allow-mongo-client"
  network = "${data.google_compute_network.terra-env-network.name}"
  depends_on = [ "data.google_compute_network.terra-env-network" ]

  allow {
    protocol = "tcp"
    ports = [ "27017"]
  }

  source_ranges = [ "${split(",", var.internal_range)}" ]
  target_tags = [ "mongodb" ]
}

resource "google_compute_firewall" "managed_managed_allow_https" {
  name = "managed-managed-allow-https"
  network = "${data.google_compute_network.terra-env-network.name}"
  depends_on = [ "data.google_compute_network.terra-env-network" ]

  allow {
    protocol = "tcp"
    ports = [ "443"]
  }

  source_ranges = [ "${split(",", var.internal_range)}" ]
  target_tags = [ "https-server" ]
}

resource "google_compute_firewall" "managed_managed_allow_http" {
  name = "managed-managed-allow-http"
  network = "${data.google_compute_network.terra-env-network.name}"
  depends_on = [ "data.google_compute_network.terra-env-network" ]

  allow {
    protocol = "tcp"
    ports = [ "80"]
  }

  source_ranges = [ "${split(",", var.internal_range)}" ]
  target_tags = [ "http-server" ]
}
