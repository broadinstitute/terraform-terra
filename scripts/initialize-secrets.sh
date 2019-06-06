#!/bin/bash

# this program will grab the initial secrets from vault
# will do the initial render of TF file point to state

# this is an initial hack for the moment

RENDER_DIR="${PWD}/files"
TERRA_ENV_ID=${TERRA_ENV_ID:-$1}


mkdir -p ${RENDER_DIR}

FILE_LIST=$(ls *.ctmpl)
cp ${FILE_LIST} ${RENDER_DIR}

docker run -t --rm -e TERRA_ENV_ID=${TERRA_ENV_ID} -v ${RENDER_DIR}:/working -v ${HOME}/.vault-token:/root/.vault-token broadinstitute/dsde-toolbox:dev /usr/local/bin/render-ctmpls.sh ${FILE_LIST}

mv ${RENDER_DIR}/terraform.tf .

