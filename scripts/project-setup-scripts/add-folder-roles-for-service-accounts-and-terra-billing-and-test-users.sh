#!/usr/bin/env bash
# set up folder access for Rawls and Cromwell SAs, as well as billing and project-owners
# In order to successfully run this script, you must first `gcloud auth login` as a gcloud user with resourcemanager.projects.setIamPolicy permissions

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195

set -euxo pipefail


ENV=$1
VALID_ENVS="Valid ENVs:
        dev
        qa
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
  # set FOLDER_ID and SA email based on the env
  if [[ "${ENV}" == "dev" ]] ; then
    FOLDER_ID=599966635789 # folder: test.firecloud.org/dev
  elif [[ "${ENV}" == "qa" ]]; then
    FOLDER_ID=950154083315 # folder: test.firecloud.org/tools (no QA folder)
  elif [[ "${ENV}" == "perf" ]]; then
    FOLDER_ID=1076814209841 # folder: test.firecloud.org/perf
  elif [[ "${ENV}" == "alpha" ]]; then
    FOLDER_ID=829384679571 # folder: test.firecloud.org/alpha
  elif [[ "${ENV}" == "staging" ]]; then
    FOLDER_ID=362889920837 # folder: test.firecloud.org/staging
  elif [[ "${ENV}" == "prod" ]]; then
    FOLDER_ID="TBD" # folder: firecloud.org/prod # todo: to be created as part of https://broadworkbench.atlassian.net/browse/CA-1194
  else
    echo "ENV was not valid."
    echo "${VALID_ENVS}"
    exit 1
  fi
fi

RAWLS_SA=$(docker run -e VAULT_TOKEN="$(cat ~/.vault-token)" -it broadinstitute/dsde-toolbox:dev vault read -field="client_email" secret/dsde/firecloud/${ENV}/rawls/rawls-account.json)
CROMWELL_SA=$(docker run -e VAULT_TOKEN="$(cat ~/.vault-token)" -it broadinstitute/dsde-toolbox:dev vault read -field="client_email" secret/dsde/firecloud/${ENV}/cromwell/cromwell-account.json)

gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=serviceAccount:"${RAWLS_SA}" --role=roles/editor
gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=serviceAccount:"${CROMWELL_SA}" --role=roles/editor

# prod only needs the terra-billing group
if [[ "${ENV}" == "prod" ]]; then
  gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:terra-billing@firecloud.org --role=roles/owner
else # for non-prod envs, add terra-billing as well as project owner groups
  gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:terra-billing@test.firecloud.org --role=roles/owner
  gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:firecloud-project-owners@test.firecloud.org --role=roles/owner

  # for the QA env, add quality.firecloud.org users as well
  if [[ "${ENV}" == "qa" ]]; then
    gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:terra-billing@quality.firecloud.org --role=roles/owner
    gcloud resource-manager folders add-iam-policy-binding "${FOLDER_ID}" --member=group:firecloud-project-owners@quality.firecloud.org --role=roles/owner
  fi
fi
