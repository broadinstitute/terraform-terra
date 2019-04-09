# ServiceUsage API
resource "google_project_service" "serviceusage" {
  provider = "google"
  project = "${var.uber_project}"
  service = "serviceusage.googleapis.com"
}

# cloudresourcemanager API
resource "google_project_service" "cloudresourcemanager" {
  provider = "google"
  project = "${var.uber_project}"
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "iam" {
  provider = "google"
  project = "${var.uber_project}"
  service = "iam.googleapis.com"
  depends_on = ["google_project_service.cloudresourcemanager","google_project_service.serviceusage"]
}
