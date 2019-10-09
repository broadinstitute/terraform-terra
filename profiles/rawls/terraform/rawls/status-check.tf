resource "google_monitoring_uptime_check_config" "http-status-check-frontend" {
  project = "${var.google_project}"
  display_name = "${var.service}-status"
  timeout = "60s"

  http_check {
    path = "/status"
    use_ssl = "true"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "${var.google_project}"
      host = "${module.load-balanced-instances.service_hostname}"
    }
  }
}

resource "google_monitoring_uptime_check_config" "http-status-check-backend" {
  project = "${var.google_project}"
  display_name = "${var.service}-backend-status"
  timeout = "60s"

  http_check {
    path = "/status"
    use_ssl = "true"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "${var.google_project}"
      host = "${var.owner}-${var.service}-backend.${data.google_dns_managed_zone.dns-zone.dns_name}"
    }
  }
}
