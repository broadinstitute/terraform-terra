# GCE Load Balancer: SSL Certificate - Red Instance
resource "google_compute_ssl_certificate" "terra-env-wildcard-ssl-certificate-red" {
  name = "${var.owner}-terra-env-wildcard-ssl-certificate-red"
  description = "SSL certificate for wildcard.dsde-qa.broadinstitute.org - Red Instance"
  private_key = "${file("./terra-env-wildcard-ssl-certificate-red.key")}"
  certificate = "${file("./terra-env-wildcard-ssl-certificate-red.crt")}"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = ["module.enable-services"]
}

# GCE Load Balancer: SSL Certificate - Black Instance
resource "google_compute_ssl_certificate" "terra-env-wildcard-ssl-certificate-black" {
  name = "${var.owner}-terra-env-wildcard-ssl-certificate-black"
  description = "SSL certificate for wildcard.dsde-qa.broadinstitute.org - Black Instance"
  private_key = "${file("./terra-env-wildcard-ssl-certificate-black.key")}"
  certificate = "${file("./terra-env-wildcard-ssl-certificate-black.crt")}"

  lifecycle {
    create_before_destroy = true
  }
  depends_on = ["module.enable-services"]
}
