provider "google" {
    alias = "gsuite-admin-sa"
    project = "${var.gsuite_admin_google_project}"
    region = "${var.gsuite_admin_region}"
}

provider "google" {
    alias = "intermediate-dns-zone"
    credentials = "${file("intermediate_dns_zone_svc.json")}"
    project = "${var.intermediate_dns_zone_google_project}"
    region = "${var.intermediate_dns_zone_region}"
}

provider "google" {
    alias = "intermediate-dns-zone-delegation"
    credentials = "${file("intermediate_dns_zone_delegation_svc.json")}"
    project = "${var.intermediate_dns_zone_delegation_google_project}"
    region = "${var.intermediate_dns_zone_delegation_region}"
}

provider "vault" {}
