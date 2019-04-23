variable "region" {
  default = "us-central1-a"
}

variable "uber_project" {
  default = ""
}

variable "terra_env_owner_service_account_name" {
  default = "terra-env-owner"
}

variable "uber_reader_service_account_name" {
  default = "terraform-reader"
}

variable "uber_owner_service_account_name" {
  default = "terraform"
}

variable "uber_reader_service_account_iam_roles" {
  type = "list"

  default = [
    "roles/viewer",
  ]
}

variable "uber_owner_service_account_iam_roles" {
  type = "list"

  default = [
    "roles/owner",
  ]
}


