# Provider definition for the Google Project that will host the 
#  terra infrastructure

provider "google" {
    alias       = "uber"
# Future this will be diff path rendered from vault or something like that
    credentials = "${file("bootstrap/file/uber-project-reader-service-account.json")}"
    project     = "${var.uber_project}"
    region      = "${var.region}"
}
