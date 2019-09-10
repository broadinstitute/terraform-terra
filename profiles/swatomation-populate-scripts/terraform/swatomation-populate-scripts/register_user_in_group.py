from common import request_with_retries
from get_bearer_token import getFirecloudAccountToken
import sys, os

FC_SAM_URL = os.environ.get("FC_SAM_URL")
ENV = os.environ.get("ENV")
ADMIN_USER = os.environ.get("ADMIN_USER")
JSON_CREDS = os.environ.get("JSON_CREDS")


def add_user_to_managed_group(user_email, group, role, token):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(token)}
    request_with_retries(FC_SAM_URL + "api/groups/v1/{0}/{1}/{2}".format(group, role, user_email), "put", header=header, status_code=204)


admin_token = getFirecloudAccountToken(JSON_CREDS)
print "\nAdding users to groups..."

# For a user to perform 'trial_managers' functions, they must *also* be a member
if ENV == "qa":
    add_user_to_managed_group("dumbledore.admin@quality.firecloud.org", "trial_managers", "admin", admin_token)
    add_user_to_managed_group("dumbledore.admin@quality.firecloud.org", "trial_managers", "member", admin_token)
    add_user_to_managed_group("voldemort.admin@quality.firecloud.org", "trial_managers", "member", admin_token)
else:
    add_user_to_managed_group("dumbledore.admin@test.firecloud.org", "trial_managers", "admin", admin_token)
    add_user_to_managed_group("dumbledore.admin@test.firecloud.org", "trial_managers", "member", admin_token)
    add_user_to_managed_group("voldemort.admin@test.firecloud.org", "trial_managers", "member", admin_token)
