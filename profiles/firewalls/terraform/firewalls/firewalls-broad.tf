
# firewall rules that allow broad ips to access services

resource "google_compute_firewall" "terra-allow-http" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-allow-http"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "80" ]
  }

  source_ranges = var.broad_range_cidrs
  target_tags = [ "http-server" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-allow-https" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-allow-https"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = var.broad_range_cidrs
  target_tags = [ "http-server" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-allow-ssh" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-allow-ssh"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = var.broad_range_cidrs
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-allow-opendj" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-allow-opendj"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "389", "636", "4444", "8443" ]
  }

  source_ranges = var.broad_range_cidrs
  target_tags = [ "opendj" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-allow-mongo" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-allow-mongo"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "27017" ]
  }

  source_ranges = var.broad_range_cidrs
  target_tags = [ "mongodb" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-allow-elasticsearch" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-allow-elasticsearch"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "9200", "9300" ]
  }

  source_ranges = var.broad_range_cidrs
  target_tags = [ "elasticsearch" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}
