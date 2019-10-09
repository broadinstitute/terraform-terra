import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")

class AddSAScopes(object):
    def run(self, context):
        print(
            "\nIn the GSuite admin console for {0}, go to:".format(
                context["google_app_domain"]
            )
        )
        print(" Security -> Advanced Settings -> Manage API client access")
        print("For each numeric {0} SA ID that was output when this profile was run, add these scopes:".format(context["app"]))
        print("https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/cloud-billing,https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.user,email,profile,openid")
        wait_for_enter()

class DomainWideDelegation(object):
    def run(self, context):
        print("\nIn the GCP console go to IAM > Service accounts:")
        print("  https://console.cloud.google.com/iam-admin/serviceaccounts")
        print("Find the {0} service account (search for '{0}')".format(context["app"]))
        print("Enable domain-wide delegation for that account\n")
        wait_for_enter()

if __name__ == "__main__":
    context = {
        "app": "firecloud-orchestration",
        "dns_domain": "dsde-perf.broadinstitute.org",
        "google_app_domain": "test.firecloud.org"
    }
    procedure = [
        AddSAScopes(),
        DomainWideDelegation()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
