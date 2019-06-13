#!/bin/sh

# This script is a quick and dirty way of grabbing a list of jenkins servers
# that should be allowed to SSH into this project

# PID
PID=$$

# Working tempfiles
TMPFILE1="/tmp/${PID}-raw.txt"
TMPFILE2="/tmp/${PID}-format.txt"

# Destination file
IPFILE="jenkins-ips.txt"

cleanup() {
  rm -f ${TMPFILE1} ${TMPFILE2}
}

# this query only gets RUNNING nodes tagged firecloud and  not prod
gcloud compute --project broad-dsp-techops instances list --format="table[no-heading](networkInterfaces.accessConfigs.natIP)"  --filter='(tags.items:firecloud AND NOT tags.items:prod) AND status:RUNNING' | cut -d "'" -f2 | sort | awk ' NR==1 { printf("%s/32",$1);next} { printf(",%s/32",$1) } ' > ${TMPFILE2}

if [ ! -s  ${TMPFILE2} ]
then
   echo "Error: list of jenkins server is empty - unexpected!!"
   exit 1
fi

if [ ! -f "${IPFILE}" ]
then
  # ensure file exists
  touch ${IPFILE}
fi
  
# check if data is different
cmp -s ${TMPFILE2} ${IPFILE}
retcode=$?

if [ "${retcode}" -ne 0 ]
then
  # file updated overwrite with new data
  cp ${TMPFILE2} ${IPFILE}
  echo "IP list is new - file is updated!!"
  echo "You should run:"
  echo "  git add ${IPFILE}"
  echo "  git commit -m \"New Jenkins IP list\"  ${IPFILE}"
  echo "  git push "
  echo "Optional step: "
  echo "    ./terraform.sh plan --out=plan.out "
  echo "    ./terraform.sh apply plan.out "

else
  echo "No update necessary"
fi

cleanup
exit 0
