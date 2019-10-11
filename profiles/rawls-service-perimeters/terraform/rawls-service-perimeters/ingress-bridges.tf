# Advanced Rawls VPC-SC configuration for data ingest. This may only be
# necessary in certain configurations, depending on data and enforcement needs.
# See this [design](https://docs.google.com/document/d/1EHw5nisXspJjA9yeZput3W4-vSIcuLBU5dPizTnk1i0/edit) for details.

data "google_project" "ingress_project" {
  for_each = var.ingress_bridges
  project_id = each.value.ingress_project_id
}

data "google_project" "protected_project" {
  for_each = var.ingress_bridges
  project_id = each.value.protected_project_id
}

resource "google_access_context_manager_service_perimeter" "ingress-bridge" {
  for_each = var.ingress_bridges

  parent      = "accessPolicies/${var.access_policy_name}"
  name        = "accessPolicies/${var.access_policy_name}/servicePerimeters/${each.key}_ingress_bridge"
  title       = "${each.key}_ingress_bridge"
  perimeter_type = "PERIMETER_TYPE_BRIDGE"
  status {
    resources = [
      "projects/${data.google_project.ingress_project[each.key].number}",
      "projects/${data.google_project.protected_project[each.key].number}"
    ]
  }
}

resource "google_access_context_manager_service_perimeter" "ingress-perimeter" {
  for_each = var.ingress_bridges

  parent      = "accessPolicies/${var.access_policy_name}"
  name        = "accessPolicies/${var.access_policy_name}/servicePerimeters/${each.key}_ingress"
  title       = "${each.key}_ingress"
  status {
    resources = ["projects/${data.google_project.ingress_project[each.key].number}"]
    # Unrestricted, to allow for ingress.
    restricted_services = []
  }
}
