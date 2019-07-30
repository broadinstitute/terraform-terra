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
        print("Add {0} to the list of authorized domains\n".format(context["dns_domain"]))
        wait_for_enter()

class Oauth(object):
    def run(self, context):
        origins = """
            https://{0}-{1}.{2}
            https://{0}-firecloud.{2}
        """.format(
            context["project_name"],
            context["app"],
            context["dns_domain"]
        )
        redirects = """
            https://{0}-{1}.{2}/oauth2callback
            https://{0}-{1}.{2}/o2c.html
            https://{0}-firecloud.{2}/oauth2callback
            https://{0}-firecloud.{2}/o2c.html
            https://{0}-firecloud-orchestration.{2}/o2c.html
            https://{0}-sam.{2}/o2c.html
            https://{0}-thurloe.{2}/o2c.html
        """.format(
            context["project_name"],
            context["app"],
            context["dns_domain"]
        )
        print("\nIn the GCP console go to APIs & Services > Credentials:")
        print("  https://console.cloud.google.com/apis/credentials")
        print("Create a new 'OAuth client ID' credential, selecting 'Web application' for the type")
        print("  Add the following authorized Javascript origins:\n" + origins)
        print("  Add the following authorized redirect URIs:\n{0}\n".format(redirects))
        wait_for_enter()
        print("\nDownload the OAuth credential JSON")
        print("Upload the JSON to vault:")
        print((
            "  docker run --rm -it "
            "-v ${{HOME}}/.vault-token:/root/.vault-token "
            "-v ~/Downloads:/downloads broadinstitute/dsde-toolbox "
            "vault write secret/dsde/firecloud/ephemeral/{0}/{1}/{1}-oauth-credential.json "
            "/downloads/[JSON file name]\n"
            ).format(
                context["project_name"],
                context["app"]
            )
        )
        wait_for_enter()

class CreateGroups(object):
    def run(self, context):
        print("\nIn the GSuite admin console (https://admin.google.com) for 'test.firecloud.org', go to:")
        print(" Groups -> Create group -> Create 2 Groups:")
        print("Admins:")
        print("  Name: fc-admins-{0}".format(context["project_name"]))
        print("  Email: fc-ADMINS@{0}.{1}".format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print("  Access type: Restricted")
        wait_for_enter()
        print("Curators:")
        print("  Name: fc-curators-{0}".format(context["project_name"]))
        print("  Email: fc-CURATORS@{0}.{1}".format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print("  Access type: Restricted\n")
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
        CreateGroups()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")