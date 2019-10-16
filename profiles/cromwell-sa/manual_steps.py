import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")

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
        "app": "cromwell",
        "project_name": sys.argv[1]
    }
    procedure = [
        AddToGroup()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
