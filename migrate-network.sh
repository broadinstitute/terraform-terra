#!/bin/bash

TERRAFORM_CMD="${1}"

# e.g. google_compute_network.terra-app-services-net
EXISTING_NETWORK_TERRAFORM_NAME="${2}"

# e.g. module.network
NEW_NETWORK_MODULE_TF_PATH="${3}"

# e.g. broad-wb-perf2-terra-network -- the name of the network in the google console
NETWORK_NAME="${4}"

GOOGLE_PROJECT="${5}"

function terraform() {
  $TERRAFORM_CMD $@
}

function import_subnet() {
  region="${1}"
  number="${2}"
  terraform import "$NEW_NETWORK_MODULE_TF_PATH.google_compute_subnetwork.subnet-with-logging[${number}]" "projects/$GOOGLE_PROJECT/regions/$region/subnetworks/$NETWORK_NAME"
}

terraform state rm $EXISTING_NETWORK_TERRAFORM_NAME
terraform import $NEW_NETWORK_MODULE_TF_PATH.google_compute_network.app-services projects/$GOOGLE_PROJECT/global/networks/$NETWORK_NAME
import_subnet "us-central1" "0"
import_subnet "europe-west1" "1"
import_subnet "us-west1" "2"
import_subnet "asia-east1" "3"
import_subnet "us-east1" "4"
import_subnet "asia-northeast1" "5"
import_subnet "asia-southeast1" "6"
import_subnet "us-east4" "7"
import_subnet "australia-southeast1" "8"
import_subnet "europe-west2" "9"
import_subnet "europe-west3" "10"
import_subnet "southamerica-east1" "11"
import_subnet "asia-south1" "12"
import_subnet "northamerica-northeast1" "13"
import_subnet "europe-west4" "14"
import_subnet "europe-north1" "15"
import_subnet "us-west2" "16"
import_subnet "asia-east2" "17"
import_subnet "europe-west6" "18"
import_subnet "asia-northeast2" "19"
