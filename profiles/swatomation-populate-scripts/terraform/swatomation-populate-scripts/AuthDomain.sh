#!/bin/bash

# Create Auth Domains in Firecloud
echo "Creating auth domains: $FC_ORCH_URL"
COMMAND=$1

function createAuthDomain {
    echo "Creating $1"
    echo "Owner: $2"
    AUTH_TOKEN=`python get_bearer_token.py "${2}" "${JSON_CREDS}"`
    echo "Token: $AUTH_TOKEN"
    response=$(curl --write-out "%{http_code}\n" --silent --output "curlout.txt" -X POST "${FC_ORCH_URL}api/groups/${1}" -H "Authorization: Bearer $AUTH_TOKEN" -H 'Content-Type: application/json')
    echo "${FC_ORCH_URL}api/groups/${1} : $response"

    if [ $response -ne 201 ]; then
        echo "Auth Domain $1 create failed with status: $response"
        cat curlout.txt
        exit 1
    fi

    # add users to auth domain
    for i in ${@:3}
    do
        echo "Adding $i to group $1"
        response=$(curl --write-out "%{http_code}\n" --silent --output "curlout.txt" -X PUT "${FC_ORCH_URL}api/groups/${1}/member/${i}" -H "Authorization: Bearer $AUTH_TOKEN" -H 'Content-Type: application/json')
        echo "${FC_ORCH_URL}api/groups/${1}/member/${i} : $response"

        if [ $response -ne 204 ]; then
            echo "Add $i to group $1 failed with status: $response"
            cat curlout.txt
            exit 1
        fi
    done

}

function deleteAuthDomain {
    echo "Deleting domain: $1"
    echo "Owner: $2"
    AUTH_TOKEN=`python get_bearer_token.py "${2}" "${JSON_CREDS}"`
    echo "Token: $AUTH_TOKEN"
    response=$(curl --write-out "%{http_code}\n" --silent --output "curlout.txt" -X DELETE "${FC_ORCH_URL}api/groups/${1}" -H "Authorization: Bearer $AUTH_TOKEN" -H 'Content-Type: application/json')
    echo "${FC_ORCH_URL}api/groups/${1} : $response"

    if [ $response -ne 204 ]; then
        echo "Auth domain delete failed with status: $response"
        cat curlout.txt
        exit 1
    fi
}

function getAuthDomainName {
    AUTH_TOKEN=`python get_bearer_token.py "${1}" "${JSON_CREDS}"`
    response=$(curl --write-out "%{http_code}\n" --silent --output "curlout.txt" -X GET "${FC_ORCH_URL}api/groups" -H "Authorization: Bearer $AUTH_TOKEN" -H 'Content-Type: application/json')

    if [ $response -ne 200 ]; then
        echo "Get Auth Domains failed with status: $response"
        cat curlout.txt
        exit 1
    fi

    cat curlout.txt | jq '.[0].groupName'
}