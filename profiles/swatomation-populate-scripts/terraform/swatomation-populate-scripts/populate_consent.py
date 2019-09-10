from common import request_with_retries
import sys, os
import json

ENV = os.environ.get("ENV")
TOKEN = os.environ.get("TOKEN")
DNS_DOMAIN = os.environ.get("DNS_DOMAIN")

print "\nPopulating consent..."
header = {"Authorization": "Bearer {0}".format(TOKEN)}

files = {"ontology_file": open("data-use.owl", "rb"),
         "metadata": json.dumps({"ontology_file": {"prefix": "DUOS", "type": "Organization"}})}

url = "https://firecloud-fiab.{0}:27443/api/ontology".format(DNS_DOMAIN)
request_with_retries(url, "post", header=header, files=files)
