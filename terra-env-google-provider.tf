# Provider definition for the Google Project that will host the 
#  terra infrastructure

provider "google" {
    alias       = "terra-env"
# Future this will be diff path rendered from vault or something like that
    credentials = "${file("files/terra-env-owner-service-account.json")}"
    project     = "${var.terra_env_project}"
    region      = "${var.region}"
}
