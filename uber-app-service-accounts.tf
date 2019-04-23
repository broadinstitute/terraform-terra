
# This creates data resources for all the application SA used by Terra

data "google_service_account" "agora" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "agora-qa"
}

data "google_service_account" "billing" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "billing"
}

data "google_service_account" "bigquery" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "bigquery-qa"
}

data "google_service_account" "consent" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "consent-qa"
}

data "google_service_account" "cromwell" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "cromwell-qa"
}

data "google_service_account" "firecloud" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "firecloud-qa"
}

data "google_service_account" "free-trial-billing-manager" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "free-trial-billing-manager"
}

data "google_service_account" "leonardo" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "leonardo-qa"
}

data "google_service_account" "rawls" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "rawls-qa"
}

data "google_service_account" "sam" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "sam-qa"
}

data "google_service_account" "thurloe" {
  count      = "${var.phase1_enable}"
  provider   = "google.uber"
  project    = "${var.uber_project}"
  account_id = "thurloe-qa"
}

