output "ATTENTION!!!" {
  value = "\nTHIS PROFILE REQUIRES MANUAL STEPS!\nSee manual_steps.py in the profile folder!\n\n"
}

output "rawls_sa_id" {
  value = "${google_service_account.app.unique_id}"
}
