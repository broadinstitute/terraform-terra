data "google_client_config" "stackdriver" {
  provider = "google.stackdriver"
}

resource "google_monitoring_uptime_check_config" "http-status-check" {
  project = "${data.google_client_config.stackdriver.project}"
  display_name = "${var.service}-status"
  timeout = "60s"

  http_check {
    path = "${var.owner}-${var.google_project}/status"
    use_ssl = "true"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = "${var.google_project}"
      host = regex("https://(\\S*)/\\S*", google_cloudfunctions_function.function.https_trigger_url)[0]
    }
  }

  depends_on = [
    "null_resource.function_upload",
    "module.enable-services"
  ]
}
