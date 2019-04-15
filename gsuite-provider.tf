provider "gsuite" {
  credentials = "gsuite_svc.json"
  impersonated_user_email = "${var.gsuite_admin}@${var.gsuite_domain}"
}
