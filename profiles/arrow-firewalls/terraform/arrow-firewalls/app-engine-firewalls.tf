resource "google_app_engine_firewall_rule" "default-deny" {
  project = "${var.google_project}"
  priority = 2147483646
  action = "DENY"
  source_range = "*"
}

resource "google_app_engine_firewall_rule" "allow-orch" {
  count = "${length(var.allowed_source_ips)}"
  project = "${var.google_project}"
  priority = 1000 + count.index
  action = "ALLOW"
  source_range = "${var.allowed_source_ips[count.index]}"
}
