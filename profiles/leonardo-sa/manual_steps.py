import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")

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
            "if it's not already there\n"
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
            "[vault path output by this profile]"
            ).format(
                context["project_name"],
                context["app"]
            )
        )
        wait_for_enter()

class AddToGroups(object):
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
        print("\nIn the GSuite admin console (https://admin.google.com) for 'test.firecloud.org', go to:")
        print(" Groups -> Search for perfx-leo-service-accounts@test.firecloud.org -> Add members:")
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
        "app": "leonardo",
        "dns_domain": "broadinstitute.org",
        "google_app_domain": "ephemeral.test.firecloud.org",
        "project_name": sys.argv[1]
    }
    procedure = [
        DomainWideDelegation(),
        AuthorizeDomain(),
        Oauth(),
        AddToGroups()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
