# VPC flow log based egress alerting per AoU RW Service Perimeter
# https://docs.google.com/document/d/1SiQokcrilgX12_gmgXPap2CHM-VZ3ohS4pKeLIrQGBI/edit#

locals {
  content_dir           = pathexpand("${path.module}")
  content_template_path = pathexpand("${local.content_dir}/egress_window_template.json")
  query_path            = pathexpand("${local.content_dir}/query.txt")

  # A static map that contains the 3 alerts thresholds we need. Since this is the same for all envs, and highly
  # possible that we want to change them all together, use a static variables here instead of define this as input.
  sumologic_egress_thresholds = {
    alert_low_60sec_50mib = {
      egress_threshold_mib = 50
      egress_window_sec    = 60
      cron_expression      = "0 * * * * ? *"
      time_range           = "-5m"
      schedule_type        = "RealTime"
    }
    alert_mid_10min_150mib = {
      egress_threshold_mib = 150
      egress_window_sec    = 600
      cron_expression      = "0 * * * * ? *"
      time_range           = "-5m"
      schedule_type        = "RealTime"
    }
    alert_high_60min_200mib= {
      egress_threshold_mib = 200
      egress_window_sec    = 3600
      cron_expression      = "0 0 * * * ? *"
      time_range           = "-12m"
      schedule_type        = "1Hour"
    }
  }

  // build a map with that contains all egress configurations.
  vpc_flow_alert_configs = { for entry in setproduct(keys(var.vpc_flow_egress_alerts), keys(local.sumologic_egress_thresholds)) :
  "${entry[1]}_${entry[0]}" => merge(lookup(var.vpc_flow_egress_alerts, entry[0]), lookup(local.sumologic_egress_thresholds, entry[1]))
  }

  queries_rendered = { for egress_rule, alert_config in local.vpc_flow_alert_configs :
  tostring(egress_rule) => templatefile(local.query_path, {
    aou_env                           = lookup(alert_config, "aou_env", "")
    egress_threshold_mib              = lookup(alert_config, "egress_threshold_mib", "")
    egress_window_sec                 = lookup(alert_config, "egress_window_sec", "")
    sumologic_source_category_name    = lookup(alert_config, "sumologic_source_category_name", "")
  })
  }

  queries_encoded = { for egress_rule, query_text in local.queries_rendered :
  egress_rule => jsonencode(query_text)
  }

  # Build a map of rendered Content templates for use in the sumologic_content resource and
  # module outputs
  egress_rule_to_config = { for egress_rule, alert_config in local.vpc_flow_alert_configs :
  egress_rule => templatefile(local.content_template_path, {
    aou_env            = lookup(alert_config, "aou_env", "")
    webhook_id            = lookup(alert_config, "webhook_id", "")
    egress_threshold_mib = lookup(alert_config, "egress_threshold_mib", 0)
    egress_window_sec    = lookup(alert_config, "egress_window_sec", 0)
    cron_expression      = lookup(alert_config, "cron_expression", 0)
    schedule_type        = lookup(alert_config, "schedule_type", 0)
    sumologic_source_category_name        = lookup(alert_config, "sumologic_source_category_name", 0)
    time_range           = lookup(alert_config, "time_range", 0)
    query_text           = lookup(local.queries_encoded, egress_rule)
  })
  }
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
  for_each              = var.vpc_flow_egress_alerts

  name                  = replace("${each.key}-alerts", "_", "-")
  project_id            = replace("${each.key}-alerts", "_", "-")
  folder_id             = google_folder.folder[each.key].id
}

# A Pub/Sub topic to publish VPC flow logs
resource "google_pubsub_topic" "vpc-flow-pubsub-topic" {
  for_each   = var.vpc_flow_egress_alerts

  project    = google_project.egress-alert-project[each.key].name
  name       = replace("${each.key}-pubsub-topic", "_", "-")
}

# Log sink on AoU RW Service Perimeter folder and publish using Pub/Sub
resource "google_logging_folder_sink" "vpc-flow-log-sink" {
  for_each         = var.vpc_flow_egress_alerts

  name             = "${each.key}-vpc-flow-log-sink"
  folder           = google_folder.folder[each.key].name
  destination      = "pubsub.googleapis.com/${google_pubsub_topic.vpc-flow-pubsub-topic[each.key].id}"
  filter           = "logName:\"/logs/compute.googleapis.com%2Fvpc_flows\""
  include_children = true
}

# The Sumologic collector
resource "sumologic_collector" "vpc-flow-logs" {
  name        = replace("terra-${var.terra_environment}-vpc-flow-log-collector", "_", "-")
  description = "Sumologic collector"
}

# Sumologic GCP Source receives log data where the Pub/Sub message is published to.
resource "sumologic_gcp_source" "sumologic-vpc-flow-log-source" {
  for_each      = var.vpc_flow_egress_alerts

  name          = "gcp/vpcflowlogs/aou/${lookup(lookup(var.vpc_flow_egress_alerts, each.key), "sumologic_source_category_name")}"
  description   = "Sumologic GCP Source receives log data from Google Pub/Sub"
  category      = "gcp"
  collector_id  = sumologic_collector.vpc-flow-logs.id
}

# Subscribe flow log topic used by the Sumologic source above.
resource "google_pubsub_subscription" "vpc-flow-pubsub-subscription" {
  for_each   = var.vpc_flow_egress_alerts

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
  for_each  = local.vpc_flow_alert_configs
  
  parent_id = lookup(lookup(local.vpc_flow_alert_configs, each.key), "sumologic_parent_folder_id_hexadecimal")
  config    = lookup(local.egress_rule_to_config, each.key, "")
}
