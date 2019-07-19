output "ATTENTION!!!" {
  value = "\nTHIS PROFILE REQUIRES MANUAL STEPS!\nSee manual-steps.md in the profile folder!\n\n"
}

output "directory_sa_ids" {
  value = "${google_service_account.directory_sa_group.*.unique_id}"
}

output "sam_sa_ids" {
  value = "${google_service_account.app.unique_id}"
}
