resource "google_monitoring_uptime_check_config" "http-status-check" {
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
