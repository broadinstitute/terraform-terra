resource "google_cloudfunctions_function" "function" {
  name                  = "${var.owner}-${var.environment}-${var.service}"
  project               = "${var.google_project}"
  description           = "${var.service}"
  available_memory_mb   = "${var.function_available_memory_mb}"
  source_archive_bucket = "${google_storage_bucket.function-deploy.name}"
  source_archive_object = "${var.function_archive_bucket_path}/${var.function_archive_bucket_filename}"
  timeout               = "${var.function_timeout}"
  service_account_email = "${data.google_service_account.function.email}"
  entry_point           = "${var.function_entrypoint}"
  runtime               = "${var.function_runtime}"
  trigger_http          = true
  environment_variables = "${var.function_env_vars}"
  depends_on = [
    "null_resource.function_upload",
    "module.enable-services"
  ]
}
