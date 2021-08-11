#!/usr/bin/env bash
# set up folder access for Rawls and Cromwell SAs, as well as billing and project-owners
# In order to successfully run this script, you must first `gcloud auth login` as a gcloud user with resourcemanager.projects.setIamPolicy permissions

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195

set -euxo pipefail

ENV=${1:-""}
VALID_ENVS="Valid ENVs:
        dev
        fiab-dev
        fiab-qa
        perf
        alpha
        staging
        prod
       "

if [[ -z "${ENV}" ]]; then
  echo "Usage: ./add-folder-roles-to-service-accounts.sh <ENV>"
  echo "${VALID_ENVS}"
  exit 1
else
  vault_env="${ENV}"
  if [[ "${ENV}" == "dev" ]] ; then
    FOLDER_ID=599966635789 # folder: test.firecloud.org/dev
    APPS_DOMAIN="test.firecloud.org"
  elif [[ "${ENV}" == "fiab-dev" ]] ; then
    FOLDER_ID=950154083315 # folder: test.firecloud.org/tools (folder for dev FIABs)
    APPS_DOMAIN="test.firecloud.org"
    vault_env=dev
  elif [[ "${ENV}" == "fiab-qa" ]]; then
    FOLDER_ID=147754536561 # folder: quality.firecloud.org/quality (folder for QA FIABs)
    APPS_DOMAIN="quality.firecloud.org"
    vault_env=qa
  elif [[ "${ENV}" == "perf" ]]; then
    FOLDER_ID=1076814209841 # folder: test.firecloud.org/perf
    APPS_DOMAIN="test.firecloud.org"
  elif [[ "${ENV}" == "alpha" ]]; then
    FOLDER_ID=829384679571 # folder: test.firecloud.org/alpha
    APPS_DOMAIN="test.firecloud.org"
  elif [[ "${ENV}" == "staging" ]]; then
    FOLDER_ID=362889920837 # folder: test.firecloud.org/staging
    APPS_DOMAIN="test.firecloud.org"
  elif [[ "${ENV}" == "prod" ]]; then
    FOLDER_ID=617814117274 # folder: firecloud.org/prod
    APPS_DOMAIN="firecloud.org"
  else
    echo "ENV was not valid."
    echo "${VALID_ENVS}"
    exit 1
  fi
fi

# Service account setup
RAWLS_SA=$(docker run -e VAULT_TOKEN="$(cat ~/.vault-token)" -it broadinstitute/dsde-toolbox:dev vault read -field="client_email" secret/dsde/firecloud/${vault_env}/rawls/rawls-account.json)
CROMWELL_SA=$(docker run -e VAULT_TOKEN="$(cat ~/.vault-token)" -it broadinstitute/dsde-toolbox:dev vault read -field="client_email" secret/dsde/firecloud/${vault_env}/cromwell/cromwell-account.json)
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=serviceAccount:"${RAWLS_SA}" --role=roles/editor --condition=None
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=serviceAccount:"${RAWLS_SA}" --role=roles/resourcemanager.projectMover --condition=None
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=serviceAccount:"${RAWLS_SA}" --role=roles/resourcemanager.projectIamAdmin --condition=None
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=serviceAccount:"${CROMWELL_SA}" --role=roles/editor --condition=None

# Billing and admin group setup
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:terra-billing@${APPS_DOMAIN} --role=roles/owner  --condition=None
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:firecloud-project-owners@${APPS_DOMAIN} --role=roles/owner  --condition=None

echo "Success"
