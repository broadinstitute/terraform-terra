# Optional log sinks on projects in a Rawls service perimeter, applied at the
# aggregate folder level. For more details, see:
# https://docs.google.com/document/d/1gzMuZSFOgFa_usCtPHWzGdwEcfexQN70Q6uI4sy5n-E/edit

locals {
  bigquery_sink_dataset_id = "WorkspaceBigQueryLogs"
  storage_sink_dataset_id = "WorkspaceStorageLogs"
  dataproc_sink_dataset_id = "WorkspaceDataprocLogs"
}

data "google_project" "audit-logs-project" {
  for_each   = var.audit_logs_project_ids
  project_id = each.value
}

resource "google_logging_folder_sink" "bigquery-audit-sink" {
  for_each   = var.audit_logs_project_ids

  name        = "${each.key}-bigquery-audit-sink"
  folder      = google_folder.folder[each.key].name
  destination = "bigquery.googleapis.com/projects/${each.value}/datasets/${local.bigquery_sink_dataset_id}"
  filter      = "logName:\"/logs/cloudaudit.googleapis.com%2Fdata_access\" AND resource.type=\"bigquery_resource\""

  include_children = true
  bigquery_options {
    use_partitioned_tables = true
  }
}

resource "google_logging_folder_sink" "storage-audit-sink" {
  for_each   = var.audit_logs_project_ids

  name        = "${each.key}-storage-audit-sink"
  folder      = google_folder.folder[each.key].name
  destination = "bigquery.googleapis.com/projects/${each.value}/datasets/${local.storage_sink_dataset_id}"
  filter      = "logName:\"/logs/cloudaudit.googleapis.com%2Fdata_access\" AND resource.type=\"gcs_bucket\""

  include_children = true
  bigquery_options {
    use_partitioned_tables = true
  }
}

resource "google_logging_folder_sink" "dataproc-audit-sink" {
  for_each   = var.audit_logs_project_ids

  name        = "${each.key}-dataproc-audit-sink"
  folder      = google_folder.folder[each.key].name
  destination = "bigquery.googleapis.com/projects/${each.value}/datasets/${local.dataproc_sink_dataset_id}"
  filter      = "resource.type=\"cloud_dataproc_cluster\" AND (logName:\"/logs/welder\" OR logName:\"/logs/jupyter\")"

  include_children = true
  bigquery_options {
    use_partitioned_tables = true
  }
}

resource "google_bigquery_dataset" "bigquery-sink-dataset" {
  for_each   = var.audit_logs_project_ids

  project  = each.value
  dataset_id  = local.bigquery_sink_dataset_id
  description = "BigQuery audit log sink for projects in Terra perimeter ${each.key}"

  labels = {
    perimeter = each.key
  }

  access {
    role   = "roles/bigquery.dataEditor"
    # TODO: replace -> trimprefix once we're on TF >=0.12.17.
    user_by_email = replace(
      google_logging_folder_sink.bigquery-audit-sink[each.key].writer_identity,
      "serviceAccount:",
      "")
  }
}

resource "google_bigquery_dataset" "storage-sink-dataset" {
  for_each   = var.audit_logs_project_ids

  project  = each.value
  dataset_id  = local.storage_sink_dataset_id
  description = "Storage audit log sink for projects in Terra perimeter ${each.key}"

  labels = {
    perimeter = each.key
  }

  access {
    role   = "roles/bigquery.dataEditor"
    user_by_email = replace(
      google_logging_folder_sink.bigquery-audit-sink[each.key].writer_identity,
      "serviceAccount:",
      "")
  }
}

resource "google_bigquery_dataset" "dataproc-sink-dataset" {
  for_each   = var.audit_logs_project_ids

  project  = each.value
  dataset_id  = local.dataproc_sink_dataset_id
  description = "Dataproc audit log sink for projects in Terra perimeter ${each.key}"

  labels = {
    perimeter = each.key
  }

  access {
    role   = "roles/bigquery.dataEditor"
    user_by_email = replace(
      google_logging_folder_sink.bigquery-audit-sink[each.key].writer_identity,
      "serviceAccount:",
      "")
  }
}

