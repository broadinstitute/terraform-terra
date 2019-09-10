from common import getUserToken, request_with_retries

import datetime
import os

# pip install google-cloud-datastore==1.7.0
from google.cloud import datastore

appNamespace = 'app'
appKind = 'Application'
tosKind = 'TermsOfService'
respKind = 'TOSResponse'
JSON_CREDS = os.environ.get("JSON_CREDS")
json_creds_path = "/tmp/creds.json"
env = os.environ.get("ENV")


def create_client():
    project = "broad-workbench-tos-" + env
    creds_file = open(json_creds_path, "w+")
    creds_file.write(JSON_CREDS)
    creds_file.close()
    return datastore.Client.from_service_account_json(json_credentials_path=json_creds_path, project=project)


# -------------------------------------------------------------------------------------------------------------


def app_key(client, name):
    return client.key(appKind, name, namespace=appNamespace)


def tos_key(client, appName, tosName):
    return client.key(tosKind, tosName, namespace=appNamespace, parent=app_key(client, appName))


def response_partial_key(client, appName, tosName):
    return client.key(respKind, namespace=appNamespace, parent=tos_key(client, appName, tosName))


# -------------------------------------------------------------------------------------------------------------


def insert_app(client, name):
    app = datastore.Entity(app_key(client, name))
    client.put(app)


def insert_tos(client, appName, tosName):
    tos = datastore.Entity(tos_key(client, appName, tosName))

    tos.update({
        'timestamp': unicode(datetime.datetime.now().__str__())
    })

    client.put(tos)


def insert_response(client, appName, tosName, userEmail, userId):
    response = datastore.Entity(response_partial_key(client, appName, tosName))

    # NOTE!  unless you convert to unicode, it stores Python 2 strings as Blob / base64 encoded

    response.update({
        'accepted': True,
        'email': unicode(userEmail, 'utf-8'),
        'timestamp': unicode(datetime.datetime.now().__str__()),
        'userid': unicode(userId, 'utf-8')
    })

    client.put(response)


# -------------------------------------------------------------------------------------------------------------


def delete_app(client, name):
    client.delete(app_key(client, name))


def delete_tos(client, appName, tosName):
    client.delete(tos_key(client, appName, tosName))


def delete_all_responses_for_pair(client, appName, tosName):
    query = client.query(kind=respKind)
    query.namespace = appNamespace
    query.ancestor = tos_key(client, appName, tosName)
    query.keys_only()

    keys = list([entity.key for entity in query.fetch()])
    client.delete_multi(keys)


# -------------------------------------------------------------------------------------------------------------


def create_tos(client, name, version):
    insert_app(client, name)
    insert_tos(client, name, version)

    print "Populated TOS App {} and Version {}".format(name, version)


def accept_tos(auth_token, env, host, version):
    tos_url = "https://us-central1-broad-workbench-tos-" + env + ".cloudfunctions.net/tos/v1/user/response"
    header = {"Authorization": "Bearer {0}".format(auth_token), "Content-Type": "application/json"}
    payload = {"appid": host, "tosversion": int(version), "accepted": True}
    request_with_retries(tos_url, "post", header=header, data=payload)


# -------------------------------------------------------------------------------------------------------------


def delete_responses(client, name, version):
    delete_all_responses_for_pair(client, name, version)
    print "Deleted TOSResponses for App {} and Version {}".format(name, version)


def delete_app_and_tos(client, name, version):
    delete_app(client, name)
    delete_tos(client, name, version)
    print "Deleted TOS App {} and Version {}".format(name, version)
