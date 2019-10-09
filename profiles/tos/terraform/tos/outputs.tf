output "function_endpoint" {
  value = "${google_cloudfunctions_function.function.https_trigger_url}"
}
