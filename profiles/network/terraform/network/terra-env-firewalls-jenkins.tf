
# Firewall rules allowing DSP FC jenkins servers to access instances in
#  TERRA_ENV google project

resource "google_compute_firewall" "jenkins_ssh" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "jenkins-ssh"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = [ "${split(",",file("jenkins-ips.txt"))}" ]
}

resource "google_compute_firewall" "jenkins_elasticsearch" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "jenkins-elasticsearch"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "9200", "9300" ]
  }

  source_ranges = [ "${split(",",file("jenkins-ips.txt"))}" ]
  target_tags = [ "elasticsearch" ]
}

resource "google_compute_firewall" "jenkins_https" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "jenkins-https"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "443" ]
  }

  source_ranges = [ "${split(",",file("jenkins-ips.txt"))}" ]
  target_tags = [ "https-server" ]
}

resource "google_compute_firewall" "jenkins_http" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "jenkins-http"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "80" ]
  }

  source_ranges = [ "${split(",",file("jenkins-ips.txt"))}" ]
  target_tags = [ "http-server" ]
}

resource "google_compute_firewall" "jenkins_ldap" {
  provider = "google.terra-env"
  count = "${var.phase3_enable}"
  name = "jenkins-ldap"
  network = "${google_compute_network.app-services-net.name}"
  depends_on = [ "google_compute_network.app-services-net" ]

  allow {
    protocol = "tcp"
    ports = [ "636" ]
  }

  source_ranges = [ "${split(",",file("jenkins-ips.txt"))}" ]
  target_tags = [ "opendj" ]
}

