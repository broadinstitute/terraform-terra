import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")

class AddSubdomain(object):
    def run(self, context):
        print(
            "\nIn the GSuite admin console (https://admin.google.com) for {0}, go to:".format(
                context["google_app_domain"]
            )
        )
        print(" Domains -> Manage Domains -> Add a domain")
        print("Click on \"Add another domain\" (NOT domain alias)")
        print(" Name: {0}.ephemeral.{1}".format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print(
            "On the ownership verification page that follows, "
            "select Google Domains as the provider, and copy the verification text.\n"
        )
        wait_for_enter()

class AddVerificationTxt(object):
    def run(self, context):
        print("\nIn a new tab, in the GCP console go to:")
        print((
            " Network services -> "
            "Cloud DNS -> "
            "{0}.ephemeral.{1} -> "
            "Add record set\n"
            " (https://console.cloud.google.com/net-services/dns/zones/{0}-gsuite-domain-zone/rrsets/create?project={0})"
            ).format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        print(
            "Change type to TXT, paste the verification text "
            "into the TXT data field, and save the record"
        )
        print("Wait ~5 mins\n")
        wait_for_enter()

class VerifySubdomain(object):
    def run(self, context):
        print("\nBack in the GSuite admin console, click \"verify\"")
        print(
            "You should get a screen congradulating you on verifying "
            "your ownership of the domain. If not, wait 5 more minutes "
            "and try clicking verify again.\n"
        )
        wait_for_enter()

class AdminAlias(object):
    def run(self, context):
        print((
            "\nIn the GSuite admin console for {0}, "
            "go to Users -> google@{0} AKA \"Google Administrator\""
            ).format(
                context["google_app_domain"]
            )
        )
        print("Click on the user, then User information")
        print((
            "Edit the list of Email aliases and add an alias to "
            "google@{0}.ephemeral.{1}\n"
            ).format(
                context["project_name"],
                context["google_app_domain"]
            )
        )
        wait_for_enter()

class AddSAScopes(object):
    def run(self, context):
        print(
            "\nIn the GSuite admin console for {0}, go to:".format(
                context["google_app_domain"]
            )
        )
        print(" Security -> Advanced Settings -> Manage API client access")
        print("For each numeric {0} SA ID that was output when this profile was run, add these scopes:".format(context["app"]))
        print("https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.user,https://www.googleapis.com/auth/apps.groups.settings\n")
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

class MakeProjectCreator(object):
    def run(self, context):
        print("\nIn the GCP console for the 'test.firecloud.org' org, go to IAM:")
        print("  https://console.cloud.google.com/iam-admin/iam?organizationId=400176686919&supportedpurview=project")
        print("Add {0} SA:".format(context["app"]))
        print("  {0}-{1}@{2}.iam.gserviceaccount.com ".format(
                context["project_name"],
                context["app"],
                context["project_name"]
            )
        )
        print("  With the 'Project Creator' role")
        wait_for_enter()

if __name__ == "__main__":
    context = {
        "app": "sam",
        "dns_domain": "dsde-perf.broadinstitute.org",
        "google_app_domain": "test.firecloud.org",
        "project_name": sys.argv[1]
    }
    procedure = [
        AddSubdomain(),
        AddVerificationTxt(),
        VerifySubdomain(),
        AdminAlias(),
        AddSAScopes(),
        DomainWideDelegation(),
        AuthorizeDomain(),
        # Oauth() Don't think SAM needs this?
        AddToGroup(),
        MakeProjectCreator()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")