#!/bin/bash

set -e

WORKING_DIR=${1:-$PWD}
VAULT_TOKEN=${2:-$(cat $HOME/.vault-token)}
ENV=${3:-dev}
APPS_DOMAIN=${4:-${ENV}.test.firecloud.org}
USER=${5:-hermione.owner@${APPS_DOMAIN}}
DNS_DOMAIN=${6:-dsde-${ENV}.broadinstitute.org}
VAULT_ADDR=${7:-https://clotho.broadinstitute.org:8200}


DOCKERHOST=`docker network inspect FiaB-Lite | jq --raw-output '.[0].IPAM.Config | .[0].Gateway'`

if [[ -z $DOCKERHOST ]]; then
    echo "IPAM.Config.Gateway not found.  Either the FiaB network is not running or the Docker daemon may need a reload."
    echo "See https://github.com/moby/moby/issues/26799 for details."
    exit 2
fi

JSON_CREDS=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=$VAULT_ADDR broadinstitute/dsde-toolbox vault read -format=json secret/dsde/firecloud/${ENV}/common/firecloud-account.json | jq '.data'`
DB_PASSWORD=`docker run --rm -e VAULT_TOKEN=$VAULT_TOKEN -e VAULT_ADDR=$VAULT_ADDR broadinstitute/dsde-toolbox vault read -format=json secret/dsde/firecloud/${ENV}/consent/secrets | jq --raw-output '.data.db_password'`
TOKEN=$(docker run --rm -v $WORKING_DIR:/app/populate -w /app/populate broadinstitute/dsp-toolbox python get_bearer_token.py "${USER}" "${JSON_CREDS}")

# Helper functions
function curlAndCatchErrors() {
    curl_call=$1
    expected_resp=$2
    retries=5
    response=$(curl --write-out "%{http_code}\n" --output "curlout.txt" --silent ${curl_call})
    echo "curl ${curl_call}: ${response}"
    while [[ $retries -ge 0 && $expected_resp -ne $response ]]; do
        echo "curl ${curl_call}: ${response}"
        if [ $retries -eq 0 ]; then
            echo "$curl_call failed with too many retries."
            exit 1
        fi
        sleep 5
        retries=$((retries-1))
        echo "retrying..."
        response=$(curl --write-out "%{http_code}\n" --silent ${curl_call})
    done

}

# populate consent / ontology
# download static files for consent / ontology so tests have stable data. Don't download latest from the DiseaseOntology repo, since
#    that data changes approximately once/week.
curl -o $WORKING_DIR/diseases.owl https://raw.githubusercontent.com/DataBiosphere/consent-ontology/develop/src/test/resources/diseases.owl
curl -o $WORKING_DIR/data-use.owl https://raw.githubusercontent.com/broadinstitute/consent-data-use/develop/src/ontology/data-use.owl

docker exec firecloud_consent-mysql_1 mysql --verbose -uconsent -p${DB_PASSWORD} -h localhost consent -e "insert into dacuser(dacUserId,email,displayName,createDate) values(22,'${USER}','${USER}','2017-06-01 22:22:22');"
docker exec firecloud_consent-mysql_1 mysql --verbose -uconsent -p${DB_PASSWORD} -h localhost consent -e "insert into user_role(role_id, user_id) values(4,22);"

docker exec firecloud_consent-mysql_1 mysql --verbose -uconsent -p${DB_PASSWORD} -h localhost consent -e "insert into dacuser(dacUserId,email,displayName,createDate) values(23,'orsp@broadinstitute.org','ORSP User','2018-01-25 00:00:00');"
docker exec firecloud_consent-mysql_1 mysql --verbose -uconsent -p${DB_PASSWORD} -h localhost consent -e "insert into user_role(role_id, user_id) values(4,23);"

docker run --rm -e TOKEN=${TOKEN} -e ENV=${ENV} -e DNS_DOMAIN=${DNS_DOMAIN} \
    --add-host="firecloud-fiab.${DNS_DOMAIN}:${DOCKERHOST}" \
    -v $WORKING_DIR:/app/populate \
    --name PopulateConsent -w /app/populate broadinstitute/dsp-toolbox \
    python populate_consent.py

docker run --rm -e TOKEN=${TOKEN} -e ENV=${ENV} -e DNS_DOMAIN=${DNS_DOMAIN} \
    --add-host="firecloud-fiab.${DNS_DOMAIN}:${DOCKERHOST}" \
    -v $WORKING_DIR:/app/populate \
    --name PopulateConsentOntology -w /app/populate broadinstitute/dsp-toolbox \
    python populate_consent_ontology.py
