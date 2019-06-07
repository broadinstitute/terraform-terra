# GCE Load Balancer: SSL Certificate - Red Instance
resource "google_compute_ssl_certificate" "terra-env-wildcard-ssl-certificate-red" {
  provider = "google.terra-env"
  count                   = "${var.phase3_enable}"
  name = "terra-env-wildcard-ssl-certificate-red"
  description = "SSL certificate for wildcard.dsde-qa.broadinstitute.org - Red Instance"
  private_key = "${file("files/terra-env-wildcard-ssl-certificate-red.key")}"
  certificate = "${file("files/terra-env-wildcard-ssl-certificate-red.crt")}"

  lifecycle {
    create_before_destroy = true
  }
 depends_on              = ["module.enable-services"]
}

# GCE Load Balancer: SSL Certificate - Black Instance
resource "google_compute_ssl_certificate" "terra-env-wildcard-ssl-certificate-black" {
  provider = "google.terra-env"
  count                   = "${var.phase3_enable}"
  name = "terra-env-wildcard-ssl-certificate-black"
  description = "SSL certificate for wildcard.dsde-qa.broadinstitute.org - Black Instance"
  private_key = "${file("files/terra-env-wildcard-ssl-certificate-black.key")}"
  certificate = "${file("files/terra-env-wildcard-ssl-certificate-black.crt")}"

  lifecycle {
    create_before_destroy = true
  }
 depends_on              = ["module.enable-services"]

}
