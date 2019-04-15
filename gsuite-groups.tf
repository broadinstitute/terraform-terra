# list of groups created per env_id

variable "gsuite_groups" {
  type = "list"

  default = [
    "fc-ADMINS",
    "fc-COMMS",
    "fc-CURATORS",
    "firecloud-project-owners",
    "firecloud-project-editors",
  ]
}

# Add the service account to the project
resource "google_project_iam_member" "gsuite-group" {
  provider = "gsuite"
  count   = "${length(var.gsuite_groups)}"
  name    = "${var.env_id}-${element(var.gsuite_groups, count.index)}"
  email = "${var.env_id}-${element(var.gsuite_groups, count.index)}@${var.gsuite_domain}"
  descriptiont = "Gsuite Group for ${element(var.gsuite_groups, count.index)} for environment ID: ${var.env_id}"
}
