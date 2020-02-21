data "google_organization" "org" {
  domain = var.org_domain
}

# Standard Rawls VPC-SC configuration:
#  - A folder to track all billing projects within the perimeter.
#  - A managed perimeter with corresponding accessLevels whitelist.
resource "google_folder" "folder" {
  for_each = var.perimeters

  parent       = "${data.google_organization.org.id}"
  display_name = each.key
}

# Perimeter folder admins are users with direct administrative access to the
# folder. For example, in All of Us, the primary service account uses these
# roles to perform administrative tasks on workspaces, such as associating the
# free tier billing account, renaming files, or checking Stackdriver egress
# metrics.
#
# This is useful when administrative accounts are not owners of the workspaces
# in their perimeter, or when they own too many workspaces and normal Google
# Group access via Sam no longer functions:
# https://docs.google.com/document/d/1-nc7hwqhM-pdJlsR-41u7zgy43kEKf8tptGhTuwbgUk/edit
resource "google_folder_iam_binding" "admin-bucket-writer" {
  for_each = var.folder_admins

  folder = google_folder.folder[each.key].name
  role = "organizations/${data.google_organization.org.id}/roles/terraBucketWriter"
  members = each.value.members
}

resource "google_folder_iam_binding" "admin-billing-manager" {
  for_each = var.folder_admins

  folder = google_folder.folder[each.key].name
  role = "roles/billing.projectManager"
  members = each.value.members
}

resource "google_folder_iam_binding" "monitoring-viewer" {
  for_each = var.folder_admins

  folder = google_folder.folder[each.key].name
  role = "roles/monitoring.viewer"
  members = each.value.members
}

resource "google_access_context_manager_access_level" "access-level" {
  for_each = var.perimeters

  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/accessLevels/${each.key}"
  title  = each.key
  basic {
    conditions {
      members = each.value.access_member_whitelist
    }
  }
}

resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  for_each = var.perimeters

  parent = "accessPolicies/${var.access_policy_name}"
  name   = "accessPolicies/${var.access_policy_name}/servicePerimeters/${each.key}"
  title  = each.key
  status {
    resources           = each.value.has_ingress_bridge ? [
      # If we have an ingress bridge configuration, we need to ensure the
      # protected project is included initially. This project must also be added
      # to the Rawls vault whitelist of perimeter projects so it isn't removed.
      "projects/${data.google_project.protected_project[each.key].number}"
    ] : []
    restricted_services = each.value.restricted_services
    access_levels = [
      google_access_context_manager_access_level.access-level[each.key].name
    ]
  }
  lifecycle {
    ignore_changes = [
      # Projects in this perimeter are managed by Rawls, as billing projects are
      # dynamically added/removed from the perimeter.
      status[0].resources
    ]
  }
}
