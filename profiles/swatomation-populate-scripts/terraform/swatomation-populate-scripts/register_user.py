#!/usr/bin/env python2.7

from common import get_users, register_firecloud_user
from get_bearer_token import getUserToken
from tos_common import accept_tos
import os

ENV = os.environ.get("ENV")
JSON_CREDS = os.environ.get("JSON_CREDS")
HOST_NAME = os.environ.get("HOST_NAME")
TOS_VERSION = os.environ.get("TOS_VERSION", 1)

print "\nRegistering users..."
def register_and_initialize_user(userargv):
    auth_token = getUserToken([userargv[3], JSON_CREDS])

    # register for FireCloud
    register_firecloud_user(*userargv, token=auth_token)

    # accept ToS
    accept_tos(auth_token, ENV, HOST_NAME, TOS_VERSION)


[register_and_initialize_user(user) for user in get_users(ENV == "qa")]
