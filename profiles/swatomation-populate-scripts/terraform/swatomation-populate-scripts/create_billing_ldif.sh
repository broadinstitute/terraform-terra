ENV=$1
EMAIL=$2
SUBJECT_ID=$3
GOOGLE_DOMAIN=$4

#creates an ldif file to populate the first user in ldap along with billing

echo "dn: resourceId=broad-dsde-$ENV,resourceType=billing-project,ou=resources,dc=dsde-$ENV,dc=broadinstitute,dc=org
objectClass: top
objectClass: resource
resourceType: billing-project
resourceId: broad-dsde-$ENV

dn: policy=owner,resourceId=broad-dsde-$ENV,resourceType=billing-project,ou=resources,dc=dsde-$ENV,dc=broadinstitute,dc=org
objectClass: policy
objectClass: workbenchGroup
objectClass: top
objectClass: groupOfUniqueNames
cn: owner
mail: GROUP_PROJECT_broad-dsde-$ENV-Owner@$GOOGLE_DOMAIN
uniqueMember: uid=$SUBJECT_ID,ou=People,dc=dsde-$ENV,dc=broadinstitute,dc=org
resourceId: broad-dsde-$ENV
resourceType: billing-project
role: owner

dn: policy=workspace-creator,resourceId=broad-dsde-$ENV,resourceType=billing-project,ou=resources,dc=dsde-$ENV,dc=broadinstitute,dc=org
objectClass: policy
objectClass: workbenchGroup
objectClass: top
cn: workspace-creator
mail: GROUP_PROJECT_broad-dsde-$ENV-workspace-creator@$GOOGLE_DOMAIN
resourceId: broad-dsde-$ENV
resourceType: billing-project
role: workspace-creator

dn: policy=can-compute-user,resourceId=broad-dsde-$ENV,resourceType=billing-project,ou=resources,dc=dsde-$ENV,dc=broadinstitute,dc=org
objectClass: policy
objectClass: workbenchGroup
objectClass: top
cn: can-compute-user
mail: GROUP_PROJECT_broad-dsde-$ENV-can-compute-user@$GOOGLE_DOMAIN
resourceId: broad-dsde-$ENV
resourceType: billing-project
role: batch-compute-user
role: notebook-user"
