module "dep-mgr-project" {
  source = "github.com/broadinstitute/terraform-shared.git//terraform-modules/google-project?ref=google-project-0.0.1-tf-0.12"
  providers = {
    google.target = "google"
  }
  project_name = var.project_name
  folder_id = var.folder_id
  billing_account_id = var.billing_account_id
  apis_to_enable = var.apis_to_enable
  service_accounts_to_grant_by_name_and_project = []
  service_accounts_to_create_with_keys = []
}
