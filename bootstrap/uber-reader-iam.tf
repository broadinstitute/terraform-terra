# Create the terraform viewer SA 
#  this SA is used to read data from uber google project without ability to
#  modify
resource "google_service_account" "uber-project-reader" {
  account_id   = "${var.uber_reader_service_account_name}"
  display_name = "Uber Project Reader SA"
  project      = "${var.uber_project}"
  depends_on = [ "google_project_service.iam" ]
}

resource "google_service_account_key" "uber-project-reader" {
  service_account_id = "${google_service_account.uber-project-reader.name}"
  depends_on = [ "google_service_account.uber-project-reader" ]
}

# Add roles to uber service account
resource "google_project_iam_member" "uber-project-reader" {
  count   = "${length(var.uber_reader_service_account_iam_roles)}"
  project = "${var.uber_project}"
  role    = "${element(var.uber_reader_service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.uber-project-reader.email}"
  depends_on = [ "google_service_account.uber-project-reader" ]
}

# save credentials
resource "local_file" "uber-project-reader-service-account-json" {
   sensitive_content = "${base64decode(google_service_account_key.uber-project-reader.private_key)}"
   filename = "file/uber-project-reader-service-account.json"
  depends_on = [ "google_service_account_key.uber-project-reader" ]
}

