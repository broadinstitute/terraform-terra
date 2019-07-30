#!/bin/bash
SCRIPT=`basename "$0"`

usage() {
  echo "${SCRIPT} FILE_PATH VAULT_PATH"
  exit ${1:-0}
}

if [[ -z "${1}" ]] ; then
  usage 1
else
  export FILE_PATH="${1}"
fi


if [[ -z "${2}" ]] ; then
  usage 1
else
  export VAULT_PATH="${2}"
fi

docker run --rm -it -v ${HOME}/.vault-token:/root/.vault-token -v "${FILE_PATH}:/file_to_upload" broadinstitute/dsde-toolbox:dev vault write "${VAULT_PATH}" @/file_to_upload
