# Provider definition for the Google Project that will host the 
#  terra infrastructure

provider "google" {
# Future this will be diff path rendered from vault or something like that
    credentials = "${file("bootstrap/file/uber-service-account.json")}"
    project     = "${var.env_project}"
    region      = "${var.region}"
}
