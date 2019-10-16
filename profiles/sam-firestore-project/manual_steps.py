import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")

class Firestore(object):
    def run(self, context):
        print("\nIn the GCP console go to Firestore:")
        print("  https://console.cloud.google.com/firestore")
        print("Enable Firestore in native mode in nam-5")
        wait_for_enter()

if __name__ == "__main__":
    context = {}
    procedure = [
        Firestore()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
