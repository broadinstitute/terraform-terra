#!/bin/bash

set -e

# Parameters
WORKING_DIR=${1:-$PWD}
VAULT_TOKEN=${2:-$(cat $HOME/.vault-token)}
ENV=${3:-dev}
DNS_DOMAIN=${4:-dsde-${ENV}.broadinstitute.org}
GOOGLE_PROJ=${5:-broad-dsde-${ENV}}
VAULT_ADDR=${6:-https://clotho.broadinstitute.org:8200}
