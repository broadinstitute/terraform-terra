#!/bin/bash

set -eu

ENV=$1
VAULT_TOKEN=$2
WORKING_DIR=$3
DNS_DOMAIN=${4:-dsde-${ENV}.broadinstitute.org}
VAULT_ADDR=${5:-https://clotho.broadinstitute.org:8200}

DOCKERHOST=`docker network inspect FiaB-Lite | jq --raw-output '.[0].IPAM.Config | .[0].Gateway'`

if [ -z $DOCKERHOST ]; then
    echo "IPAM.Config.Gateway not found.  Either the FiaB network is not running or the Docker daemon may need a reload."
    echo "See https://github.com/moby/moby/issues/26799 for details."
    exit 2
fi

echo "Populating cloud-extension/google policy for service accounts"

FC_URI="https://firecloud-orchestration-fiab.${DNS_DOMAIN}:23443"

docker pull broadinstitute/firecloud-tools

docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=${VAULT_ADDR} broadinstitute/dsde-toolbox vault read --format=json "secret/dsde/firecloud/ephemeral/$ENV/rawls/rawls-account.json" | jq .data > rawls_account.json
docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=${VAULT_ADDR} broadinstitute/dsde-toolbox vault read --format=json "secret/dsde/firecloud/ephemeral/$ENV/sam/sam-account.json" | jq .data > sam_account.json
docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=${VAULT_ADDR} broadinstitute/dsde-toolbox vault read --format=json "secret/dsde/firecloud/ephemeral/$ENV/leonardo/leonardo-account.json" | jq .data > leo_account.json

RAWLS_EMAIL=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=${VAULT_ADDR} broadinstitute/dsde-toolbox vault read -field=client_email "secret/dsde/firecloud/ephemeral/$ENV/rawls/rawls-account.json"`
SAM_EMAIL=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=${VAULT_ADDR} broadinstitute/dsde-toolbox vault read -field=client_email "secret/dsde/firecloud/ephemeral/$ENV/sam/sam-account.json"`
LEO_EMAIL=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=${VAULT_ADDR} broadinstitute/dsde-toolbox vault read -field=client_email "secret/dsde/firecloud/ephemeral/$ENV/leonardo/leonardo-account.json"`

docker run --add-host="firecloud-orchestration-fiab.${DNS_DOMAIN}:${DOCKERHOST}" --rm -v "$PWD/rawls_account.json:/account.json" -v "$HOME"/.config:/.config broadinstitute/firecloud-tools python scripts/register_service_account/register_service_account.py -j /account.json -e $RAWLS_EMAIL -u $FC_URI
docker run --add-host="firecloud-orchestration-fiab.${DNS_DOMAIN}:${DOCKERHOST}" --rm -v "$PWD/leo_account.json:/account.json" -v "$HOME"/.config:/.config broadinstitute/firecloud-tools python scripts/register_service_account/register_service_account.py -j /account.json -e $LEO_EMAIL -u $FC_URI
docker run --add-host="firecloud-orchestration-fiab.${DNS_DOMAIN}:${DOCKERHOST}" --rm -v "$PWD/sam_account.json:/account.json" -v "$HOME"/.config:/.config broadinstitute/firecloud-tools python scripts/register_service_account/register_service_account.py -j /account.json -e $SAM_EMAIL -u $FC_URI

SAM_TOKEN=`docker run --rm -v "$PWD/sam_account.json:/account.json" broadinstitute/firecloud-tools python scripts/get_access_token.py account.json | tr -d "\r"`

docker run --rm -v $WORKING_DIR:/app --add-host="sam-fiab.${DNS_DOMAIN}:${DOCKERHOST}" \
    broadinstitute/dsp-toolbox python /app/request_with_retries.py \
    --url=https://sam-fiab.${DNS_DOMAIN}:29443/api/resource/cloud-extension/google/policies/fc-service-accounts \
    --method=put --statusCode=201 --headers="{\"content-type\": \"application/json\", \"Authorization\": \"bearer ${SAM_TOKEN}\"}" \
    --insecure --data="{\"memberEmails\": [\"$RAWLS_EMAIL\", \"$LEO_EMAIL\"],\"actions\": [\"get_pet_private_key\"],\"roles\": []}"


rm rawls_account.json sam_account.json leo_account.json

# get it to visually verify
docker run --rm -v $WORKING_DIR:/app --add-host="sam-fiab.${DNS_DOMAIN}:${DOCKERHOST}" \
    broadinstitute/dsp-toolbox python /app/request_with_retries.py \
    --url=https://sam-fiab.${DNS_DOMAIN}:29443/api/resource/cloud-extension/google/policies/fc-service-accounts \
    --method=get --statusCode=200 --headers="{\"content-type\": \"application/json\", \"Authorization\": \"bearer ${SAM_TOKEN}\"}" --insecure
