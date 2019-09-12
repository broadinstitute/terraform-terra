# Create the token / function storage bucket
resource "google_storage_bucket" "function-deploy" {
  name          = "${var.owner}-${var.environment}-${var.service}-function-deploy"
  project       = "${var.google_project}"
  force_destroy = true
  storage_class = "MULTI_REGIONAL"
}
