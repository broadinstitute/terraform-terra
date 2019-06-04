variable "region" {
  default = "us-central1"
}

# uber project where SAs live 
variable "uber_project" {
  default = ""
}

# project where terra infrastructure resides
variable "terra_env_project" {
  default = ""
}

# id used to be appended to all resources in shared areas
variable "terra_env_id" {
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

# The following vars are used in order to control either the phase
#  that infrastructure is built or control the creation or destruction

variable "phase1_enable" {
  default = "0"
}

variable "phase2_enable" {
  default = "0"
}

variable "phase3_enable" {
  default = "0"
}

variable "phase4_enable" {
  default = "0"
}

variable "phase5_enable" {
  default = "0"
}

variable "phase6_enable" {
  default = "0"
}

