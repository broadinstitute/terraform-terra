#!/usr/bin/env bash

# This script needs to run on the host that FiaB is running on
# This script requires the /populate directory and its scripts

set -e


WORKING_DIR=${1:-$PWD}
VAULT_TOKEN=${2:-$(cat $HOME/.vault-token)}
ENV=${3:-dev}
HOST_NAME=$4

DOCKERHOST=`docker network inspect FiaB-Lite | jq --raw-output '.[0].IPAM.Config | .[0].Gateway'`

if [[ -z $DOCKERHOST ]]; then
    echo "IPAM.Config.Gateway not found.  Either the FiaB network is not running or the Docker daemon may need a reload."
    echo "See https://github.com/moby/moby/issues/26799 for details."
    exit 2
fi

JSON_CREDS=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=https://clotho.broadinstitute.org:8200 broadinstitute/dsde-toolbox vault read -format=json secret/dsde/firecloud/${ENV}/common/firecloud-account.json | jq '.data'`

# set env-specific vars:
if [ $ENV == "qa" ]; then
    DOMAIN="quality.firecloud.org"
    USER="hermione.owner@quality.firecloud.org"
    ADMIN_USER="dumbledore.admin@quality.firecloud.org"
else
    DOMAIN="${ENV}.test.firecloud.org"
    USER="hermione.owner@test.firecloud.org"
    ADMIN_USER="dumbledore.admin@test.firecloud.org"
fi

TOKEN=`docker run --rm -v $WORKING_DIR:/app/populate -w /app/populate broadinstitute/dsp-toolbox python get_bearer_token.py "${ADMIN_USER}" "${JSON_CREDS}"`


# Basic unpopulate
bash $WORKING_DIR/basic-unpopulate-fiab.sh $WORKING_DIR $VAULT_TOKEN $ENV

# Unregister users
sh $WORKING_DIR/unregister_users.sh $ENV $VAULT_TOKEN $WORKING_DIR $TOKEN $ADMIN_USER $HOST_NAME "${JSON_CREDS}"
