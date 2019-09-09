import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")

class DB(object):
    def run(self, context):
        print("\nClone the firecloud-develop repo and ensure you are on the desired branch/commit")
        wait_for_enter()
        print("\nUpdate the {0} submodule:".format(context["app"]))
        print("git submodule init {0} && git submodule update {0}".format(context["app"]))
        wait_for_enter()
        print("Run the docker command to initialize the db that was output by this profile")
        wait_for_enter()

if __name__ == "__main__":
    context = {
        "app": "consent"
    }
    procedure = [
        DB()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
