# Service config bucket
resource "google_storage_bucket" "ping-me-bucket" {
  name       = "${var.service}-ping-me-${var.owner}"
  project    = "${var.google_project}"
  versioning {
    enabled = "true"
  }
  force_destroy = true
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "ping-me"
  }
}

# Grant service account access to the config bucket
resource "google_storage_bucket_iam_member" "ping-me-config" {
  count = "${length(var.ping_me_bucket_roles)}"
  bucket = "${google_storage_bucket.ping-me-bucket.name}"
  role   = "${element(var.ping_me_bucket_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.config_reader.email}"
}

