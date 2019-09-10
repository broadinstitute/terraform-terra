#!/bin/bash

set -eu

ENV=$1
VAULT_TOKEN=$2
WORKING_DIR=$3
MYSQLPASS=$4
DOCKERHOST=`docker network inspect FiaB-Lite | jq --raw-output '.[0].IPAM.Config | .[0].Gateway'`

if [[ -z $DOCKERHOST ]]; then
    echo "IPAM.Config.Gateway not found.  Either the FiaB network is not running or the Docker daemon may need a reload."
    echo "See https://github.com/moby/moby/issues/26799 for details."
    exit 2
fi


FC_URI="https://firecloud-orchestration-fiab.dsde-${ENV}.broadinstitute.org:23443"

docker pull broadinstitute/firecloud-tools

docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=https://clotho.broadinstitute.org:8200 broadinstitute/dsde-toolbox vault read --format=json "secret/dsde/firecloud/$ENV/common/firecloud-account.json" | jq .data > firecloud_account.json

FIRECLOUD_ACCOUNT_EMAIL=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=https://clotho.broadinstitute.org:8200 broadinstitute/dsde-toolbox vault read -field=client_email "secret/dsde/firecloud/$ENV/common/firecloud-account.json"`

docker run --add-host="firecloud-orchestration-fiab.dsde-${ENV}.broadinstitute.org:${DOCKERHOST}" --rm -v "$PWD/firecloud_account.json:/account.json" -v "$HOME"/.config:/.config broadinstitute/firecloud-tools python scripts/register_service_account/register_service_account.py -j /account.json -e $FIRECLOUD_ACCOUNT_EMAIL -u $FC_URI

FIRECLOUD_ACCOUNT_TOKEN=`docker run --rm -v "$PWD/firecloud_account.json:/account.json" broadinstitute/firecloud-tools python scripts/get_access_token.py account.json | tr -d "\r"`

for GROUP in trial_managers; do
	echo "Creating group $GROUP"
	docker run --rm -v $WORKING_DIR:/app --add-host="firecloud-orchestration-fiab.dsde-${ENV}.broadinstitute.org:${DOCKERHOST}" \
	    broadinstitute/dsp-toolbox python /app/request_with_retries.py \
	    --url=${FC_URI}/api/groups/${GROUP} \
	    --method=post --statusCode=201 --headers="{\"content-type\": \"application/json\", \"Authorization\": \"bearer $FIRECLOUD_ACCOUNT_TOKEN\"}" \
	    --insecure
done

rm firecloud_account.json
