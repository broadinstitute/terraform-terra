# VPC flow log based egress alerting per AoU RW Service Perimeter
# https://docs.google.com/document/d/1SiQokcrilgX12_gmgXPap2CHM-VZ3ohS4pKeLIrQGBI/edit#


# Pull Sumologic credentials from Vault
data "vault_generic_secret" "sumologic-secret-path" {
  path = "secret/dsde/firecloud/dev/aou/sumologic"
}

provider "sumologic" {
  access_id   = data.vault_generic_secret.sumologic-secret-path.data["access_id"]
  access_key  = data.vault_generic_secret.sumologic-secret-path.data["access_key"]
  environment = "us2"
}

# Creates the project to host Pub/Sub topic and subscription
resource "google_project" "egress-alert-project" {
  for_each              = var.perimeters

  name                  = replace("${each.key}-alerts", "_", "-")
  project_id            = replace("${each.key}-alerts", "_", "-")
  folder_id             = google_folder.folder[each.key].id
}

# A Pub/Sub topic to publish VPC flow logs
resource "google_pubsub_topic" "vpc-flow-pubsub-topic" {
  for_each   = var.perimeters

  project    = google_project.egress-alert-project[each.key].name
  name       = replace("${each.key}-pubsub-topic", "_", "-")
}

# Log sink on AoU RW Service Perimeter folder and publish using Pub/Sub
resource "google_logging_folder_sink" "vpc-flow-log-sink" {
  for_each         = var.perimeters

  name             = "${each.key}-vpc-flow-log-sink"
  folder           = google_folder.folder[each.key].name
  destination      = "pubsub.googleapis.com/${google_pubsub_topic.vpc-flow-pubsub-topic[each.key].id}"
  filter           = "logName:\"/logs/compute.googleapis.com%2Fvpc_flows\""
  include_children = true
}

# The Sumologic collector
resource "sumologic_collector" "vpc-flow-logs" {
  for_each      = var.perimeters

  name        = replace("${each.key}-vpc-flow-log-collector", "_", "-")
  description = "Sumologic collector"
}

# Sumologic GCP Source receives log data where the Pub/Sub message is published to.
resource "sumologic_gcp_source" "sumologic-vpc-flow-log-source" {
  for_each      = var.perimeters

  name          = replace("${each.key}-vpc-flow-log-source", "_", "-")
  description   = "Sumologic GCP Source receives log data from Google Pub/Sub"
  category      = "gcp"
  collector_id  = sumologic_collector.vpc-flow-logs[each.key].id
}

# Subscribe flow log topic used by the Sumologic source above.
resource "google_pubsub_subscription" "vpc-flow-pubsub-subscription" {
  for_each   = var.perimeters

  project    = google_project.egress-alert-project[each.key].name
  name       = replace("${each.key}-pubsub-sub", "_", "-")
  topic      = google_pubsub_topic.vpc-flow-pubsub-topic[each.key].name

  ack_deadline_seconds = 20

  expiration_policy {
    // No expiration
    ttl = ""
  }

  push_config {
    push_endpoint = sumologic_gcp_source.sumologic-vpc-flow-log-source[each.key].url

    attributes = {
      x-goog-version = "v1"
    }
  }
}
