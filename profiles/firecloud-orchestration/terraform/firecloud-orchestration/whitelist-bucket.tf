# whitelist bucket
resource "google_storage_bucket" "whitelist-bucket" {
  name       = "${var.owner}-${var.service}-whitelist"
  project    = "${var.google_project}"
  versioning {
    enabled = "true"
  }
  # Do we want to add encryption to this bucket?
  force_destroy = true
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "whitelist"
  }
}

# Grant service account access to the config bucket
resource "google_storage_bucket_iam_member" "whitelist-bucket" {
  count = "${length(var.whitelist_bucket_roles)}"
  bucket = google_storage_bucket.whitelist-bucket.name
  role   = "${element(var.whitelist_bucket_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.config_reader.email}"
}
