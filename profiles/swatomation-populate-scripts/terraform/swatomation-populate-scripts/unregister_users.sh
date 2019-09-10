#!/bin/bash
set -u

ENV=$1
VAULT_TOKEN=$2
WORKING_DIR=$3
TOKEN=$4
ADMIN_EMAIL=$5
HOST_NAME=$6
JSON_CREDS=$7
DOCKERHOST=`docker network inspect FiaB-Lite | jq --raw-output '.[0].IPAM.Config | .[0].Gateway'`
TOS_VERSION="1"

echo "Deleting user ToS responses"
docker run --rm -e JSON_CREDS="${JSON_CREDS}" \
    -e HOST_NAME="${HOST_NAME}" -e TOS_VERSION=${TOS_VERSION} -e ENV="${ENV}" \
    -v $WORKING_DIR:/app/populate --name UnregisterToS -w /app/populate \
    broadinstitute/dsp-toolbox python unregister_tos.py

if [[ -z $DOCKERHOST ]]; then
    echo "IPAM.Config.Gateway not found.  Either the FiaB network is not running or the Docker daemon may need a reload."
    echo "See https://github.com/moby/moby/issues/26799 for details."
    exit 2
fi

LDAP_PASSWORD=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=https://clotho.broadinstitute.org:8200 broadinstitute/dsde-toolbox vault read -field=ldap_password "secret/dsde/firecloud/$ENV/sam/sam.conf"`
SAM_OPENDJ_CONTAINER=firecloud_sam-opendj_1

docker ps | grep $SAM_OPENDJ_CONTAINER
if [ $? -eq 0 ]; then
    SUBJECT_ID=`timeout 600 docker exec $SAM_OPENDJ_CONTAINER ldapsearch -h localhost -p 390 -D "cn=Directory Manager" -w $LDAP_PASSWORD -b "ou=people,dc=dsde-${ENV},dc=broadinstitute,dc=org" -s one "(mail=$ADMIN_EMAIL)" uid | grep "uid:" | cut -f2 -d" "`

    if [ ! -z "$SUBJECT_ID" ]; then
        timeout 600 docker exec $SAM_OPENDJ_CONTAINER ldapsearch -h localhost -p 390 -D "cn=Directory Manager" -w $LDAP_PASSWORD -b "ou=people,dc=dsde-${ENV},dc=broadinstitute,dc=org" -s one '(!(cn=proxy-ro))' uid | grep "uid:" | cut -f2 -d" " | grep -v $SUBJECT_ID > uids.txt

        if [ -s uids.txt ]; then
            while read uid; do
                echo "unregistering $uid"
                docker run --rm -v $WORKING_DIR:/app --add-host="sam-fiab.dsde-${ENV}.broadinstitute.org:${DOCKERHOST}" \
                    broadinstitute/dsp-toolbox python /app/request_with_retries.py \
                    --url=https://sam-fiab.dsde-${ENV}.broadinstitute.org:29443/api/admin/user/$uid \
                    --method=delete --statusCode=200 --headers="{\"content-type\": \"application/json\", \"Authorization\": \"bearer ${TOKEN}\"}"
            done <uids.txt
        fi

        echo "unregistering admin $SUBJECT_ID"
        docker run --rm -v $WORKING_DIR:/app --add-host="sam-fiab.dsde-${ENV}.broadinstitute.org:${DOCKERHOST}" \
            broadinstitute/dsp-toolbox python /app/request_with_retries.py \
            --url=https://sam-fiab.dsde-${ENV}.broadinstitute.org:29443/api/admin/user/$SUBJECT_ID \
            --method=delete --statusCode=200 --headers="{\"content-type\": \"application/json\", \"Authorization\": \"bearer ${TOKEN}\"}"
    else
        echo "[WARN] No admin user found in ldap; cannot unregister users."
    fi
else
    echo "[WARN] $SAM_OPENDJ_CONTAINER is not running; cannot unregister users."
fi
