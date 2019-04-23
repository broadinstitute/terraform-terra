#!/bin/bash

TERRA_ENV_PROJECT=${TERRA_ENV_PROJECT:-$1}

# check if default network exists
network=$(gcloud compute --project ${TERRA_ENV_PROJECT} networks list --filter=name="default"   --format="table[no-heading](name)")

if [ ! -z "${network}" ]
then
  rules=$(gcloud compute --project ${TERRA_ENV_PROJECT} firewall-rules list --filter=network="default"  --format="table[no-heading](name)" )
  if [ ! -z "${rules}" ]
  then
     echo "${rules}" | while read rule 
     do

        # echo "${rule}: ${rules}"
        # delete rule
        gcloud -q compute --project ${TERRA_ENV_PROJECT} firewall-rules delete ${rule}

     done

  fi
  # delete network
  gcloud -q compute --project ${TERRA_ENV_PROJECT} networks delete default

fi
