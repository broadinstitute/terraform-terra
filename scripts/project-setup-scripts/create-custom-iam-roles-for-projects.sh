#!/usr/bin/env bash
#create custom roles in each environment's google project

set -euxo pipefail

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195

ORGANIZATION_ID=$1

if [[ -z "${ORGANIZATION_ID}" ]]
then
  echo "Usage: ./create-custom-iam-roles-for-projects.sh <ORGANIZATION_ID>"
  echo "Organization IDs:
        test.firecloud.org - 400176686919
        quality.firecloud.org - 206744735509
        firecloud.org - 386193000800
       "
  exit 1
else
  gcloud iam roles create terra_workspace_can_compute --organization=${ORGANIZATION_ID} --file=terra-workspace-can-compute.yaml
  gcloud iam roles create terra_billing_project_owner --organization=${ORGANIZATION_ID} --file=terra-billing-project-owner.yaml
fi
