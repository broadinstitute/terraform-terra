variable "region" {
  default = "us-central1-a"
}

# project where terra infrastructure resides
variable "env_project" {
  default = ""
}

# id used to be appended to all resources in shared areas
variable "env_id" {
  default = ""
}

# admin user in gsuite to impersonate for gsuite provider
variable "gsuite_admin" {
  default = ""
}

# Gsuite domain name
variable "gsuite_domain" {
  default = ""
}

