import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")
 
class AuthorizeDomain(object):
    def run(self, context):
        print("\nIn the GCP console go to APIs & Services > Credentials > OAuth consent screen:")
        print("  https://console.cloud.google.com/apis/credentials/consent")
        print("Add {0} to the list of authorized domains\n".format(context["dns_domain"]))
        wait_for_enter()

class Oauth(object):
    def run(self, context):
        print("\nIn the GCP console go to APIs & Services > Credentials:")
        print("  https://console.cloud.google.com/apis/credentials")
        print("Create a new 'OAuth client ID' credential, selecting 'Web application' for the type")
        print("  Name: Refresh Token Oauth Credential")
        print("  Add the authorized Javascript origins output by this profile")
        print("  Add the following authorized redirect URIs output by this profile\n")
        wait_for_enter()
        print("\nDownload the OAuth credential JSON")
        print("Upload the JSON to vault:")
        print((
            "  ./add_to_vault.sh "
            "[path to JSON] "
            "secret/dsde/firecloud/ephemeral/{0}/common/refresh-token-oauth-credential.json\n"
            ).format(
                context["project_name"]
            )
        )
        wait_for_enter()

class CreateStackdriverWorkspace(object):
    def run(self, context):
        print("\nIn the GCP console go to Stackdriver > Monitoring > Create Workspace:")
        print("  https://app.google.stackdriver.com/accounts/create")
        print("For the workspace name, put your project name ({0})\n".format(context["project_name"]))
        wait_for_enter()

if __name__ == "__main__":
    context = {
        "dns_domain": "broadinstitute.org",
        "google_app_domain": "ephemeral.test.firecloud.org",
        "project_name": sys.argv[1]
    }
    procedure = [
        AuthorizeDomain(),
        Oauth(),
        CreateStackdriverWorkspace()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
