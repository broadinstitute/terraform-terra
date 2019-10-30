output "ATTENTION" {
  value = <<EOF
THIS PROFILE REQUIRES MANUAL STEPS!
To run the manual steps run the script in the profile root:
python manual_steps.py [google-project-name]
EOF
}

output "orch_sa_id" {
  value = "${google_service_account.app.unique_id}"
}
