from common import register_firecloud_user
from tos_common import accept_tos, create_tos, create_client
import sys, os

HOST_NAME = os.environ.get("HOST_NAME")
TOS_VERSION = os.environ.get("TOS_VERSION", 1)
TOKEN = os.environ.get("TOKEN")
ENV = os.environ.get("ENV")


print "\nCreating ToS..."
client = create_client()

create_tos(client, HOST_NAME, TOS_VERSION)


print "\nCreating initial user..."
# register for FireCloud
register_firecloud_user(*sys.argv[1:])

# accept ToS
accept_tos(TOKEN, ENV, HOST_NAME, TOS_VERSION)
