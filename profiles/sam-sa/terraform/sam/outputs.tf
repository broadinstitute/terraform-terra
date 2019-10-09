output "ATTENTION" {
  value = <<EOF
THIS PROFILE REQUIRES MANUAL STEPS!
To run the manual steps run the script in the profile root:
python manual_steps.py [google-project-name]
EOF
}

output "directory_sa_ids" {
  value = "${google_service_account.directory_sa_group.*.unique_id}"
}

output "sam_sa_ids" {
  value = "${google_service_account.app.unique_id}"
}
