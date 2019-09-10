#!/usr/bin/env python2.7

from tos_common import create_client, delete_app_and_tos, delete_responses
import os

HOST_NAME = os.environ.get("HOST_NAME")
TOS_VERSION = "1"


print "\nDeleting ToS responses..."
client = create_client()

delete_responses(client, HOST_NAME, TOS_VERSION)

print "\nDeleting ToS"
delete_app_and_tos(client, HOST_NAME, TOS_VERSION)
