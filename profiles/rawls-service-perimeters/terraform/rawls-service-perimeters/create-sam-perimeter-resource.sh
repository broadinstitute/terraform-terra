#!/usr/bin/env bash


# This script is run by terraform to create a service perimeter in Sam.

if [[ $# -ne 4 ]]; then
    echo "usage: ./create_service-perimeter.sh ENV PERIMETER_NAME POLICY_NAME OWNER_EMAIL"
    exit 1
fi

ENV=$1
PERIMETER_NAME=$2
POLICY_NAME=$3
OWNER_EMAIL=$4

SAM_HOST="https://sam.dsde-${ENV}.broadinstitute.org"
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Make sure that the user calling the script is registered in Firecloud
curl -X POST --header 'Content-Type: application/json' --header "Authorization: Bearer ${ACCESS_TOKEN}" \
 "${SAM_HOST}/register/user/v2/self"

# Create the perimeter in Sam, url encoded resourceId
STATUS=$(curl -s -o /dev/null -w '%{http_code}' -X POST --header 'Content-Type: application/json' --header "Authorization: Bearer ${ACCESS_TOKEN}" -d "{ \
   \"resourceId\": \"accessPolicies%2F${POLICY_NAME}%2FservicePerimeters%2F${PERIMETER_NAME}\", \
   \"policies\": { \
     \"owner\": { \
       \"memberEmails\": [ \
         \"${OWNER_EMAIL}\" \
       ], \
       \"actions\": [], \
       \"roles\": [ \
         \"owner\" \
       ] \
     } \
   }, \
   \"authDomain\": [] \
 }" "${SAM_HOST}/api/resources/v1/service-perimeter")

# We consider the 200s as success, and also 409 if the resource already exists. If the resource already exists, this
# script may have already run and that's ok.
if [[ $STATUS -eq '200' ]] || [[ $STATUS -eq '204' ]] || [[ $STATUS -eq '409' ]]; then
  exit 0
else
  exit $STATUS
fi
