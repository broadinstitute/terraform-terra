import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")
 
class AddSAScopes(object):
    def run(self, context):
        print("\nIn the GSuite admin console (https://admin.google.com) for 'test.firecloud.org', go to:")
        print(" Security -> Advanced Settings -> Manage API client access")
        print("For each numeric {0} SA ID that was output when this profile was run, add these scopes:".format(context["app"]))
        print("https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.user\n")
        wait_for_enter()

class DomainWideDelegation(object):
    def run(self, context):
        print("\nIn the GCP console go to IAM > Service accounts:")
        print("  https://console.cloud.google.com/iam-admin/serviceaccounts")
        print("Find the {0} service account (search for '{0}')".format(context["app"]))
        print("Enable domain-wide delegation for that account\n")
        wait_for_enter()

class AuthorizeDomain(object):
    def run(self, context):
        print("\nIn the GCP console go to APIs & Services > Credentials > OAuth consent screen:")
        print("  https://console.cloud.google.com/apis/credentials/consent")
        print((
            "Add the root domain of {0} to the list of authorized domains"
            " if it's not already there\n"
            ).format(context["dns_domain"])
        )
        wait_for_enter()

class Oauth(object):
    def run(self, context):
        print("\nIn the GCP console go to APIs & Services > Credentials:")
        print("  https://console.cloud.google.com/apis/credentials")
        print("Create a new 'OAuth client ID' credential, selecting 'Web application' for the type")
        print("  Name: {0} Oauth Credential ".format(context["app"]))
        print("  Add the authorized Javascript origins output by this profile")
        print("  Add the authorized redirect URIs output by this profile\n")
        wait_for_enter()
        print("\nDownload the OAuth credential JSON")
        print("Upload the JSON to vault:")
        print((
            "  ./add_to_vault.sh "
            "[path to JSON] "
            "[vault path output by this profile]\n"
            ).format(
                context["project_name"],
                context["app"]
            )
        )
        wait_for_enter()

class CreateGroups(object):
    def run(self, context):
        print("\nIn the GSuite admin console (https://admin.google.com) for 'test.firecloud.org', go to:")
        print("Groups -> Create group -> Create 2 Groups:")
        print("  Admins:")
        print("    Name: fc-admins-{0}".format(context["project_name"]))
        print("    Email: fc-ADMINS@{0}.{1}".format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print("    Access type: Restricted")
        wait_for_enter()
        print("  Curators:")
        print("    Name: fc-curators-{0}".format(context["project_name"]))
        print("    Email: fc-CURATORS@{0}.{1}".format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print("    Access type: Restricted")
        wait_for_enter()
        print("Add the following users to the fc-admins-{0} group".format(context["project_name"]))
        print("  fc-admin@{0}.{1}".format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print("  firecloud-orchestration@{0}.iam.gserviceaccount.com".format(
                context["project_name"]
            )
        )
        print("  dumbledore.admin@{0}".format(context["google_app_domain"]))
        print("  voldemort.admin@{0}".format(context["google_app_domain"]))
        wait_for_enter()
        print("Add the following users to the fc-curators-{0} group".format(context["project_name"]))
        print("  snape.curator@{0}".format(context["google_app_domain"]))
        print("  mcgonagall.curator@{0}\n".format(context["google_app_domain"]))
        wait_for_enter()

class AddToGroup(object):
    def run(self, context):
        print("\nIn the GSuite admin console (https://admin.google.com) for 'test.firecloud.org', go to:")
        print(" Groups -> Search for firecloud-project-editors-perf@test.firecloud.org -> Add members:")
        print("Add {0} SA:".format(context["app"]))
        print("  {0}-{1}@{2}.iam.gserviceaccount.com ".format(
                context["project_name"],
                context["app"],
                context["project_name"]
            )
        )
        wait_for_enter()

if __name__ == "__main__":
    context = {
        "app": "rawls",
        "dns_domain": "dsde-perf.broadinstitute.org",
        "google_app_domain": "ephemeral.test.firecloud.org",
        "project_name": sys.argv[1]
    }
    procedure = [
        AddSAScopes(),
        DomainWideDelegation(),
        AuthorizeDomain(),
        Oauth(),
        CreateGroups(),
        AddToGroup()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
