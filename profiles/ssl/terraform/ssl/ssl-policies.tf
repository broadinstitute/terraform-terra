resource "google_compute_ssl_policy" "tls12-ssl-policy" {
  provider        = "google"
  name            = "${ var.load_balancer_ssl_policy }"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}
