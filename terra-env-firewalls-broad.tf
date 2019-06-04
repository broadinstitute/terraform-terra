
# firewall rules that allow broad ips to access services

resource "google_compute_firewall" "broad-allow-http" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "broad-allow-http"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "80" ]
  }

  source_ranges = [ "${var.broad_range_cidrs}" ]
  target_tags = [ "http-server" ]
}

resource "google_compute_firewall" "broad-allow-https" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "broad-allow-https"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = [ "${var.broad_range_cidrs}" ]
  target_tags = [ "http-server" ]
}

resource "google_compute_firewall" "broad-allow-ssh" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "broad-allow-ssh"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = [ "${var.broad_range_cidrs}" ]
}

resource "google_compute_firewall" "broad-allow-opendj" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "broad-allow-opendj"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "389", "636", "4444", "8443" ]
  }

  source_ranges = [ "${var.broad_range_cidrs}" ]
  target_tags = [ "opendj" ]
}

resource "google_compute_firewall" "broad-allow-mongo" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "broad-allow-mongo"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "27017" ]
  }

  source_ranges = [ "${var.broad_range_cidrs}" ]
  target_tags = [ "mongodb" ]
}

resource "google_compute_firewall" "broad-allow-elasticsearch" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "broad-allow-elasticsearch"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "9200", "9300" ]
  }

  source_ranges = [ "${var.broad_range_cidrs}" ]
  target_tags = [ "elasticsearch" ]
}


