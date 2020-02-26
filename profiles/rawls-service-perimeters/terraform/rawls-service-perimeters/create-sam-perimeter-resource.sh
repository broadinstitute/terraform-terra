#!/usr/bin/env bash


# This script is run by terraform to create a service perimeter in Sam. It ensures that the caller of this script is
# a registered user (needed to create a resource in Sam) and then it creates a service-perimeter resource in Sam. The
# script is resilient to being called multiple times to create the same resource, but it will not update an already
# existing service perimeter. It also cannot be used to delete the service perimeter. It is just for initial perimeter
# setup

if [[ $# -ne 4 ]]; then
    echo "usage: ./create_service-perimeter.sh ENV PERIMETER_NAME POLICY_NAME OWNER_EMAIL"
    exit 1
fi

ENV=$1
PERIMETER_NAME=$2
POLICY_NAME=$3
OWNER_EMAIL=$4

SAM_HOST="https://sam.dsde-${ENV}.broadinstitute.org"
gcloud auth activate-service-account --key-file=./default.sa.json
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Make sure that the user calling the script is registered in Firecloud
REGISTRATION_STATUS=$(curl -s -o /dev/null -w '%{http_code}' -X POST --header 'Content-Type: application/json' --header "Authorization: Bearer ${ACCESS_TOKEN}" \
 "${SAM_HOST}/register/user/v2/self")

if [[ ${REGISTRATION_STATUS} -ne 201 ]] || [[ ${REGISTRATION_STATUS} -ne 409 ]]; then
    exit 1
fi

CREATE_PERIMETER_REQUEST_JSON=$(cat <<- EOF
{
  "resourceId": "accessPolicies%2F${POLICY_NAME}%2FservicePerimeters%2F${PERIMETER_NAME}",
  "policies": {
    "owner": {
      "memberEmails": [
        "${OWNER_EMAIL}"
      ],
      "actions": [],
      "roles": [
        "owner"
      ]
    }
  },
  "authDomain": []
}
EOF
)

# Create the perimeter in Sam, url encoded resourceId
STATUS=$(curl -s -o /dev/null -w '%{http_code}' -X POST --header 'Content-Type: application/json' --header "Authorization: Bearer ${ACCESS_TOKEN}" -d "${CREATE_PERIMETER_REQUEST_JSON}" "${SAM_HOST}/api/resources/v1/service-perimeter")

gcloud auth revoke
# We consider the 200s as success, and also 409 if the resource already exists. If the resource already exists, this
# script may have already run and that's ok.
if [[ ${STATUS} -eq '201' ]] || [[ ${STATUS} -eq '204' ]] || [[ ${STATUS} -eq '409' ]]; then
  exit 0
else
  exit $STATUS
fi