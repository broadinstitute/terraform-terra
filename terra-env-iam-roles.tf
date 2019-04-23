# Members are added to roles so instead of a resource that lists all
# the roles for a specific user/SA.  You list all the users/SAs that 
# have that role applied to them.  This means to find all the roles a
# certain user/SA has you need to look for all the roles that the user/SA
# is a member of

# Editors must be handled differently
resource "google_project_iam_member" "terra-env-billing-editor" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/editor"
  member = "serviceAccount:${data.google_service_account.billing.email}"
}

resource "google_project_iam_member" "terra-env-cromwell-editor" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/editor"
  member = "serviceAccount:${data.google_service_account.cromwell.email}"
}

resource "google_project_iam_member" "terra-env-firecloud-editor" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/editor"
  member = "serviceAccount:${data.google_service_account.firecloud.email}"
}

resource "google_project_iam_member" "terra-env-rawls-editor" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/editor"
  member = "serviceAccount:${data.google_service_account.rawls.email}"
}

resource "google_project_iam_member" "terra-env-sam-editor" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/editor"
  member = "serviceAccount:${data.google_service_account.sam.email}"
}

resource "google_project_iam_binding" "terra-env-pubsub-editors" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project  = "${var.terra_env_project}"
  role     = "roles/pubsub.editor"

  members = [
    "serviceAccount:${data.google_service_account.thurloe.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-pubsub-admins" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/pubsub.admin"

  members = [
    "serviceAccount:${data.google_service_account.sam.email}",
    "serviceAccount:${data.google_service_account.rawls.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-bigquery-jobusers" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/bigquery.jobUser"

  members = [
    "serviceAccount:${data.google_service_account.bigquery.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-cloudkms-admins" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/cloudkms.admin"

  members = [
    "serviceAccount:${data.google_service_account.sam.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-cloudsql-clients" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/cloudsql.client"

  members = [
    "serviceAccount:${data.google_service_account.consent.email}",
    "serviceAccount:${data.google_service_account.rawls.email}",
    "serviceAccount:${data.google_service_account.thurloe.email}",
    "serviceAccount:${data.google_service_account.leonardo.email}",
    "serviceAccount:${data.google_service_account.agora.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-dataproc-viewers-" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/dataproc.viewer"

  members = [
    "serviceAccount:${data.google_service_account.leonardo.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-billing-projectmanagers" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/billing.projectManager"

  members = [
    "serviceAccount:${data.google_service_account.billing.email}",
  ]
}


resource "google_project_iam_binding" "terra-env-iam-serviceAccountAdmins" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/iam.serviceAccountAdmin"

  members = [
    "serviceAccount:${data.google_service_account.sam.email}",
  ]
}

resource "google_project_iam_binding" "terra-env-storage-admins" {
  count    = "${var.phase2_enable}"
  provider = "google.terra-env"
  project = "${var.terra_env_project}"
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${data.google_service_account.leonardo.email}",
    "serviceAccount:${data.google_service_account.consent.email}",
  ]
}

