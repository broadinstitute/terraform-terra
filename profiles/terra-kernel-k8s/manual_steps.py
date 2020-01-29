import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")
 
class SetupIstio(object):
    def run(self, context):
        print("\nFollow the instructions here if you'd like to install istio on the cluster:")
        print("https://cloud.google.com/istio/docs/istio-on-gke/installing")
        print("Use Strict mTLS\n")
        wait_for_enter()

if __name__ == "__main__":
    context = {}
    procedure = [
        SetupIstio()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
