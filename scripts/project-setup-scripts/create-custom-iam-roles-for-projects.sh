#create custom roles in each environment's google project

# todo: convert this to Terraform as part of https://broadworkbench.atlassian.net/browse/CA-1195

# org: test.firecloud.org
gcloud iam roles create google-project-viewer --organization=400176686919 --file=google-project-viewer.yaml
gcloud iam roles create google-project-owner --organization=400176686919 --file=google-project-owner.yaml

# org: firecloud.org
gcloud iam roles create google-project-viewer --organization=386193000800 --file=google-project-viewer.yaml
gcloud iam roles create google-project-owner --organization=386193000800 --file=google-project-owner.yaml
