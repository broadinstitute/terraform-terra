resource "vault_generic_secret" "ping-me-bucket" {
  path = "${var.vault_path_prefix}/${var.service}/secrets/buckets/ping"

  data_json = <<EOT
{
  "bucket_name": "${google_storage_bucket.ping-me-bucket.name}"
}
EOT
}
