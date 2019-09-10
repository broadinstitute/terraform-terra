#!/bin/bash
set -e
set -x

function getSubjectId {

    TESTCREDS=`VAULT_ADDR=https://clotho.broadinstitute.org:8200 vault read -format=json secret/dsde/firecloud/ephemeral/${ENV}/common/users.json | jq --arg USERNAME ${USERNAME} '.data.users[] | select(.id_token.email==$USERNAME)'`
    echo $TESTCREDS | jq -r '.id_token.sub'

}

USERNAME=$1
ENV=$2
getSubjectId

