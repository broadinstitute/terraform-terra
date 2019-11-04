import sys
 
def wait_for_enter():
    raw_input("Press Enter to continue: ")
 
class AddToStackdriverWS(object):
    def run(self, context):
        print("\nIn the GCP console go to Stackdriver > Monitoring:")
        print("  https://console.cloud.google.com/monitoring")
        print("When prompted for the Stackdriver workspace, select the one for your main project\n")
        wait_for_enter()

if __name__ == "__main__":
    context = {}
    procedure = [
        AddToStackdriverWS()
    ]
    for step in procedure:
        step.run(context)
    print("\nAll Done!")
