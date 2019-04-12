# Initial setup

The terraform configurations in this directory 

Master Google project setup:

1. gcloud auth as a human user that is Owner in the Google project
2. Run  gcloud auth application-default login  in order to set this user as
   application default
3. Create terraform.tfvars file containing:
uber_project = "GOOGLE PROJECT NAME"
4. Run ./terraform.sh init to download 
5. Run ./terraform.sh plan --out=plan.out
6. ./terraform.sh apply plan.out
7. This creates a uber-service-account.json in the file subdirectory.  Save this somewhere safe (ie Hashicorp Vault)

Master GSuite setup:

Manual steps..

1. Get ClientID of uber-service-account.json
   jq .client_id < file/uber-service-account.json | tr -d '"'
2. Open up Gsuite Admin page - logging in as a Admin
   https://admin.google.com/AdminHome?chromeless=1&fral=1
3  Auth as GSuite admin user
  go to: https://admin.google.com/AdminHome?chromeless=1#OGX:ManageOauthClients
   Put client_id from step 1 in field labelled: Client Name
   Put the following list in the API Scopes 
https://www.googleapis.com/auth/admin.directory.customer,https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.rolemanagement,https://www.googleapis.com/auth/admin.directory.user

