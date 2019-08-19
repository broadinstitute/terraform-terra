output "terra_ui_url" {
  value = "${var.owner}-${var.environment}-${var.service}-dot-${data.google_client_config.app-engine.project}.appspot.com"
}
