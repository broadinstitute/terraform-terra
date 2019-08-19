# Service config bucket
resource "google_storage_bucket" "app-bucket" {
  provider    = "google.app-engine"
  name       = "${var.owner}-${var.environment}-${var.service}-app-engine"
  versioning {
    enabled = "true"
  }
  force_destroy = true
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "app-engine-storage"
  }
}
