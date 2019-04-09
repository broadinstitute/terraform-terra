# Create the uber owner service account
resource "google_service_account" "uber-owner" {
  account_id   = "${var.uber_owner_service_account_name}"
  display_name = "Uber Owner Service Account"
  project      = "${var.uber_project}"
  depends_on = [ "google_project_service.iam" ]
}

resource "google_service_account_key" "uber-owner" {
  service_account_id = "${google_service_account.uber-owner.name}"
  depends_on = [ "google_service_account.uber-owner" ]
}

# Add roles to uber service account
resource "google_project_iam_member" "uber-owner-service-account" {
  count   = "${length(var.uber_owner_service_account_iam_roles)}"
  project = "${var.uber_project}"
  role    = "${element(var.uber_owner_service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.uber-owner.email}"
  depends_on = [ "google_service_account.uber-owner" ]
}

# save credentials
resource "local_file" "uber-owner-service-account-json" {
   sensitive_content = "${base64decode(google_service_account_key.uber-owner.private_key)}"
   filename = "file/uber-service-account.json"
  depends_on = [ "google_service_account_key.uber-owner" ]
}

