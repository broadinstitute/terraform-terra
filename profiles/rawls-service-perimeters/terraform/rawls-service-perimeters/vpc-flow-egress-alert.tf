# VPC flow log based egress alerting per AoU RW Service Perimeter
# https://docs.google.com/document/d/1SiQokcrilgX12_gmgXPap2CHM-VZ3ohS4pKeLIrQGBI/edit#

locals {
  content_dir           = pathexpand("${path.module}/assets/content")
  search_configs        = fileset(local.content_dir, "*.json")
  content_template_path = pathexpand("${local.content_dir}/egress_window_template.json")
  query_path            = pathexpand("${local.content_dir}/query.txt")

  sumologic_egress_thresholds = {
    alert_low_60sec_50mib = {
      egress_threshold_mib = 50
      egress_window_sec    = 60
      cron_expression      = "0 * * * * ? *"
      time_range           = "-5m"
      schedule_type        = "RealTime"
    }
    alert_mid_600sec_150mib = {
      egress_threshold_mib = 150
      egress_window_sec    = 600
      cron_expression      = "0 * * * * ? *"
      time_range           = "-5m"
      schedule_type        = "RealTime"
    }
    alert_high_3600sec_200mib= {
      egress_threshold_mib = 200
      egress_window_sec    = 3600
      cron_expression      = "0 0 * * * ? *"
      time_range           = "-12m"
      schedule_type        = "1Hour"
    }
  }

  alert_configs_and_thresholds = [
  for pair in setproduct(var.vpc_flow_egress_alerts, local.sumologic_egress_thresholds) : {
    egress_alert_config = pair[0]
    egress_threshold = pair[1]
  }
  ]
}

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

  name          = concat("gcp/vpcflowlogs/aou/", lookup(lookup(vpc_flow_egress_alerts, each.key), "sumologic_source_category_name"))
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

# Simply export a content file or folder and put the JSON file in ./assets/content.
# Since the query is so long (and critical) and is json-encoded, it's easier
# to configure it separately.

resource "sumologic_content" "sumologic-vpc-flow-alert" {
  for_each  = var.alert_configs_and_thresholds
  parent_id = each.key.sumologic_parent_folder_id_hexadecimal
  config =
  config    = templatefile(local.query_path, {
    aou_env                           = each.key.aou_env
    sumologic_source_category_name    = lookup(each.key, "sumologic_source_category_name", 0)
    egress_threshold_mib              = lookup(each.value, "egress_threshold_mib", 0)
    egress_window_sec                 = lookup(each.value, "egress_window_sec", 0)
    cron_expression      = lookup(each.value, "cron_expression", 0)
    schedule_type        = lookup(each.value, "schedule_type", 0)
    time_range           = lookup(each.value, "time_range", 0)
    query_text           = lookup(local.queries_encoded, egress_rule)
  })
}

