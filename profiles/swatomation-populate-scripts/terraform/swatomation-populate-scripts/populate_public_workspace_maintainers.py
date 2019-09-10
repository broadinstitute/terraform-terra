from common import request_with_retries
from get_bearer_token import getFirecloudAccountToken
import sys, os, subprocess

FC_SAM_URL = os.environ.get("FC_SAM_URL")
ENV = os.environ.get("ENV")
JSON_CREDS = os.environ.get("JSON_CREDS")
DOMAIN = os.environ.get("DOMAIN")


def get_user_id(user_email, token):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(token)}
    r = request_with_retries(FC_SAM_URL + "api/users/v1/{0}".format(user_email), "get", header=header, status_code=200)
    return r.json()["userSubjectId"]

# For a user to perform 'trial_managers' functions, they must *also* be a member
def admin_user_ids():
    admin_token = getFirecloudAccountToken(JSON_CREDS)
    admin_emails = ["dumbledore.admin@quality.firecloud.org", "voldemort.admin@quality.firecloud.org"] if ENV=="qa" else ["dumbledore.admin@test.firecloud.org", "voldemort.admin@test.firecloud.org"]
    return [get_user_id(email, admin_token) for email in admin_emails]
    
def write_ldif(user_ids, file):
    print >>file, "dn: policy=public-setters,resourceId=workspace,resourceType=resource_type_admin,ou=resources,dc=dsde-{0},dc=broadinstitute,dc=org".format(ENV)
    print >>file, "objectClass: policy"
    print >>file, "objectClass: workbenchGroup"
    print >>file, "objectClass: top"
    print >>file, "objectClass: groupOfUniqueNames"
    print >>file, "cn: public-setters"
    print >>file, "mail: does_not_matter@{0}".format(DOMAIN)
    print >>file, "resourceId: workspace"
    print >>file, "resourceType: resource_type_admin"
    print >>file, "role: public-setters"
    for user_id in user_ids:
        print >>file, "uniqueMember: uid={0},ou=People,dc=dsde-{1},dc=broadinstitute,dc=org".format(user_id, ENV)

with open("/app/populate/public-workspace-maintainers.ldif", "w") as file:
    write_ldif(admin_user_ids(), file)
