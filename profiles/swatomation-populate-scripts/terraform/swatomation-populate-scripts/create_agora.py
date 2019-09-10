import sys, os
import json
from common import request_with_retries

FC_ORCH_URL = os.environ.get("FC_ORCH_URL")
ENV = os.environ.get("ENV")
TOKEN = os.environ.get("TOKEN")


def make_method(data):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(TOKEN)}
    request_with_retries(FC_ORCH_URL + "api/methods", "post", header=header, data=data, status_code=201)


def make_method_owner(name, namespace, acls):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(TOKEN)}
    request_with_retries(FC_ORCH_URL + "api/methods/{0}/{1}/1/permissions".format(namespace, name), "post", header=header, data=acls)


def make_method_config(method_config):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(TOKEN)}
    request_with_retries(FC_ORCH_URL + "api/configurations", "post", header=header, data=method_config, status_code=201)


def make_method_config_owner(name, namespace, acls):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(TOKEN)}
    request_with_retries(FC_ORCH_URL + "api/configurations/{0}/{1}/1/permissions".format(namespace, name), "post", header=header, data=acls)


def make_namespace_owner(namespace, acls):
    header = {"Content-Type": "application/json",
              "Authorization": "Bearer {0}".format(TOKEN)}
    request_with_retries(FC_ORCH_URL + "api/configurations/{0}/permissions".format(namespace), "post", header=header, data=acls)


print "\nCreating methods and method configs..."
agora_acls = json.load(open("agoraAcls.json"))
method_config = json.load(open("agoraconf.json"))

with open(sys.argv[1]) as agora_file:
    for line in agora_file:
        method_data = json.loads(line)
        method_name = method_data['name']
        method_namespace = method_data['namespace']

        make_method(method_data)

        if ENV == 'qa':
            make_method_owner(method_name, method_namespace, agora_acls)

make_method_config(method_config)

if ENV == "qa":
    namespace = method_config["namespace"]
    name = method_config["name"]
    make_method_config_owner(name, namespace, agora_acls)
    make_namespace_owner(namespace, agora_acls)
