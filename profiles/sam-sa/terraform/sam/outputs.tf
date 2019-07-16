output "directory_sa_ids" {
  value = "${google_service_account.directory_sa_group.*.unique_id}"
}
