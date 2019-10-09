
# Firewall rules allowing DSP FC jenkins servers to access instances in
#  TERRA_ENV google project

resource "google_compute_firewall" "terra-jenkins-ssh" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-jenkins-ssh"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = split(",",file("jenkins-ips.txt"))
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-jenkins-elasticsearch" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-jenkins-elasticsearch"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "9200", "9300" ]
  }

  source_ranges = split(",",file("jenkins-ips.txt"))
  target_tags = [ "elasticsearch" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-jenkins-https" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-jenkins-https"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = split(",",file("jenkins-ips.txt"))
  target_tags = [ "https-server" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-jenkins-http" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-jenkins-http"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "80" ]
  }

  source_ranges = split(",",file("jenkins-ips.txt"))
  target_tags = [ "http-server" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}

resource "google_compute_firewall" "terra-jenkins-ldap" {
  provider = "google-beta"
  enable_logging = true
  name = "${var.owner}-terra-jenkins-ldap"
  network = "${data.google_compute_network.terra-env-network.name}"

  allow {
    protocol = "tcp"
    ports = [ "636" ]
  }

  source_ranges = split(",",file("jenkins-ips.txt"))
  target_tags = [ "opendj" ]
  depends_on = [
    "module.enable-services",
    "data.google_compute_network.terra-env-network"
  ]
}
