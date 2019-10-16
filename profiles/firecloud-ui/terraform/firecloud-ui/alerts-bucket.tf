# FC-alerts bucket
resource "google_storage_bucket" "alerts" {
  name       = "${var.owner}-fc-alerts"
  labels = {
    "app" = "${var.service}",
    "owner" = "${var.owner}",
    "role" = "fc-alerts"
  }
}

resource "google_storage_bucket_object" "alerts_json" {
  name   = "alerts.json"
  content = "[]"
  bucket = "${google_storage_bucket.alerts.name}"
}

# Grant service account access to the bucket
resource "google_storage_bucket_iam_member" "fc_alerts" {
  count = "${length(var.storage_bucket_roles)}"
  bucket = google_storage_bucket.alerts.name
  role   = "${element(var.storage_bucket_roles, count.index)}"
  member = "serviceAccount:${data.google_service_account.app.email}"
}

# Grand public read access
resource "google_storage_default_object_access_control" "public_rule" {
  bucket = "${google_storage_bucket.alerts.name}"
  role   = "READER"
  entity = "allUsers"
}
