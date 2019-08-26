# service bucket
resource "google_storage_bucket" "service-bucket" {
  name       = "${var.owner}-${var.service}"
  project    = "${var.google_project}"
  versioning {
    enabled = "true"
  }
  # Do we want to add encryption to this bucket?
  force_destroy = true
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "${var.service}"
  }
}

# Grant service account access to the config bucket
resource "google_storage_bucket_iam_member" "service-bucket" {
  count = "${length(var.service_bucket_roles)}"
  bucket = google_storage_bucket.service-bucket.name
  role   = "${element(var.service_bucket_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.app.email}"
}
