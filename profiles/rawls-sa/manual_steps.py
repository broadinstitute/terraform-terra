import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")
 
class AddSAScopes(object):
    admin_console_url = "https://admin.google.com"
    def run(self, context):
        print("\nIn the GSuite admin console ({0}) for 'test.firecloud.org', go to:".format(self.admin_console_url))
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

class Oauth(object):
    def run(self, context):
        origins = """
            https://{0}-{1}.{2}
            https://{0}-{1}.{2}:24443
            https://{0}-firecloud.{2}:24443
        """.format(
            context["project_name"],
            context["app"],
            context["dns_domain"]
        )
        redirects = """
            https://{0}-{1}.{2}/oauth2callback
            https://{0}-{1}.{2}/o2c.html
            https://{0}-{1}.{2}:24443/oauth2callback
            https://{0}-{1}.{2}:24443/o2c.html
            https://{0}-firecloud.{2}:24443/oauth2callback
            https://{0}-firecloud.{2}:24443/o2c.html
            https://{0}-firecloud-orchestration.{2}:23443/o2c.html
            https://{0}-sam.{2}:29443/o2c.html
            https://{0}-thurloe.{2}:25443/o2c.html
        """.format(
            context["project_name"],
            context["app"],
            context["dns_domain"]
        )
        print("\nIn the GCP console go to APIs & Services > Credentials:")
        print("  https://console.cloud.google.com/apis/credentials")
        print("Create a new 'OAuth client ID' credential, selecting 'Web application' for the type")
        print("  Add the following authorized Javascript origins:\n" + origins)
        print("  Add the following authorized redirect URIs:\n" + redirects)
        wait_for_enter()

if __name__ == "__main__":
    context = {
        "app": "rawls",
        "dns_domain": "dsde-perf.broadinstitute.org",
        "project_name": sys.argv[1]
    }
    procedure = [
        AddSAScopes(),
        DomainWideDelegation(),
        Oauth()
    ]
    for step in procedure:
        step.run(context)
    print("Done.")