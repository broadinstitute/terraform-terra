variable "region" {
  default = "us-central1-a"
}

variable "uber_owner_service_account_name" {
  default = "terraform"
}

variable "uber_owner_service_account_iam_roles" {
  type = "list"

  default = [
    "roles/owner",
  ]
}


