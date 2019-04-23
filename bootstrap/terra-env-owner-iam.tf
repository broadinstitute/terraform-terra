# Create the terra env owner service account
#  this SA is used to do owner level actions on terra env projects
resource "google_service_account" "terra-env-owner" {
  account_id   = "${var.terra_env_owner_service_account_name}"
  display_name = "Terra Environment Owner Service Account"
  project      = "${var.uber_project}"
  depends_on = [ "google_project_service.iam" ]
}

resource "google_service_account_key" "terra-env-owner" {
  service_account_id = "${google_service_account.terra-env-owner.name}"
  depends_on = [ "google_service_account.terra-env-owner" ]
}

# save credentials
resource "local_file" "terra-env-owner-service-account-json" {
   sensitive_content = "${base64decode(google_service_account_key.terra-env-owner.private_key)}"
   filename = "file/terra-env-owner-service-account.json"
  depends_on = [ "google_service_account_key.terra-env-owner" ]
}

