#!/usr/bin/env python2.7

import requests
import sys, os
import time
import json
from get_bearer_token import getUserToken


def request_with_retries(url, method,
                         header=None,
                         data=None,
                         files=None,
                         status_code=200,
                         retries=5,
                         retry_sleep=10,
                         verify=True):

    def _request_method(u, m, h, d, f):
        if m == 'post':
            if files:
                return requests.post(u, headers=h, files=f, verify=verify)
            return requests.post(u, headers=h, data=json.dumps(d), verify=verify)
        elif m == 'put':
            return requests.put(u, headers=h, data=json.dumps(d), verify=verify)
        elif m == 'get':
            return requests.get(u, headers=h, verify=verify)
        elif m == 'delete':
            return requests.delete(u, headers=h, verify=verify)

    r = _request_method(url, method, header, data, files)
    curr_status = r.status_code
    print "{0} {1}: {2}".format(method.upper(), url, curr_status)
    while retries > 0 and curr_status != status_code:
        print "[WARN] Retrying..."
        time.sleep(retry_sleep)
        retries -= 1
        r = _request_method(url, method, header, data, files)
        curr_status = r.status_code
        print "[WARN] Retried {0} {1}: {2}".format(method.upper(), url, curr_status)

    # Output more error info
    if curr_status != status_code:
        print "[ERROR] {0} {1} failed with status {2}".format(method.upper(), url, curr_status)
        print r.text
        sys.exit(1)
        
    return r


def create_firecloud_user_profile(role, first_name, last_name, email):
    return {
        "pi": "Remus Lupin",
        "programLocationCountry": "USA",
        "institute": "Hogwarts",
        "firstName": first_name,
        "title": role,
        "institutionalProgram": "dsde",
        "lastName": last_name,
        "contactEmail": email,
        "nonProfitStatus": "Non-Profit",
        "programLocationState": "MA",
        "programLocationCity": "Cambridge"}


def register_firecloud_user(role, first_name, last_name, email,
                            orch_base_url=os.environ.get("FC_ORCH_URL"),
                            json_creds=os.environ.get("JSON_CREDS"),
                            token=os.environ.get("TOKEN")):
    print "Registering user {0} {1}".format(first_name, last_name)
    auth_token = getUserToken([email, json_creds]) if email.split("@")[1].split('.')[1] == 'firecloud' else token
    orch_url = orch_base_url + 'register/profile'
    header = {"Authorization": "Bearer {0}".format(auth_token), "Content-Type": "application/json"}
    profile = create_firecloud_user_profile(role, first_name, last_name, email)
    request_with_retries(orch_url, "post", header=header, data=profile)

def get_users(is_qa):
    if is_qa:
        return [
            # Admins
            ["Professor", "Albus", "Dumbledore", "dumbledore.admin@quality.firecloud.org"],
            ["Professor", "Lord", "Voldemort", "voldemort.admin@quality.firecloud.org"],

            # Curators
            ["Professor", "Minerva", "McGonagall", "mcgonagall.curator@quality.firecloud.org"],
            ["Professor", "Remus", "Lupin", "lupin.curator@quality.firecloud.org"],
            ["Professor", "Filius", "Flitwick", "flitwick.curator@quality.firecloud.org"],
            ["Professor", "Rubeus", "Hagrid", "hagrid.curator@quality.firecloud.org"],
            ["Professor", "Severus", "Snape", "snape.curator@quality.firecloud.org"],

            #Project Owners
            ["Owner", "Sirius", "Black", "sirius.owner@quality.firecloud.org"],
            ["Owner", "Nymphadora", "Tonks", "tonks.owner@quality.firecloud.org"],

            # Students
            ["Student", "Harry", "Potter", "harry.potter@quality.firecloud.org"],
            ["Student", "Ron", "Weasley", "ron.weasley@quality.firecloud.org"],
            ["Student", "Draco", "Malfoy", "draco.malfoy@quality.firecloud.org"],
            ["Student", "Lavender", "Brown", "lavender.brown@quality.firecloud.org"],
            ["Student", "Cho", "Chang", "cho.chang@quality.firecloud.org"],
            ["Student", "Oliver", "Wood", "oliver.wood@quality.firecloud.org"],
            ["Student", "Cedric", "Diggory", "cedric.diggory@quality.firecloud.org"],
            ["Student", "Vincent", "Crabbe", "vincent.crabbe@quality.firecloud.org"],
            ["Student", "Gregory", "Goyle", "gregory.goyle@quality.firecloud.org"],
            ["Student", "Dean", "Thomas", "dean.thomas@quality.firecloud.org"],
            ["Student", "Ginny", "Weasley", "ginny.weasley@quality.firecloud.org"],

            # Auth Domain Users
            ["Researcher", "Fred", "Weasley", "fred.authdomain@quality.firecloud.org"],
            ["Researcher", "George", "Weasley", "george.authdomain@quality.firecloud.org"],
            ["Researcher", "Bill", "Weasley", "bill.authdomain@quality.firecloud.org"],
            ["Researcher", "Molly", "Weasley", "molly.authdomain@quality.firecloud.org"],
            ["Researcher", "Arthur", "Weasley", "arthur.authdomain@quality.firecloud.org"],
            ["Researcher", "Percy", "Weasley", "percy.authdomain@quality.firecloud.org"]
        ]
    else:
        return [
            ["Professor", "Albus", "Dumbledore", "dumbledore.admin@test.firecloud.org"],
            ["Professor", "Lord", "Voldemort", "voldemort.admin@test.firecloud.org"],
            ["Professor", "Minerva", "McGonagall", "mcgonagall.curator@test.firecloud.org"],
            ["Professor", "Severus", "Snape", "snape.curator@test.firecloud.org"],
            ["Student", "Harry", "Potter", "harry.potter@test.firecloud.org"],
            ["Student", "Ron", "Weasley", "ron.weasley@test.firecloud.org"],
            ["Student", "Draco", "Malfoy", "draco.malfoy@test.firecloud.org"],
            ["Researcher", "Fred", "Weasley", "fred.authdomain@test.firecloud.org"],
            ["Researcher", "George", "Weasley", "george.authdomain@test.firecloud.org"],
            ["Researcher", "Bill", "Weasley", "bill.authdomain@test.firecloud.org"]
        ]
